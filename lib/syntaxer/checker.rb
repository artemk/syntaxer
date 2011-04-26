require 'set'
require "observer"
require 'thread'
module Syntaxer
  class Checker
    # include Open3
    include Observable
    extend Forwardable

    def_delegators Syntaxer::FileStatus, :error_files, :all_files
    
    attr_accessor :syntaxer, :reader
    
    def initialize(syntaxer, count)
      Printer.setup do |p|
        p.count_of_files = count
        p.mode = syntaxer.hook ? :hook : :default
      end

      add_observer(Printer)
      @syntaxer = syntaxer
      @reader = @syntaxer.reader
      @results = []
    end

    # Factory for checker
    #
    # @return [RepoChecker, #process] 

    def self.process(syntaxer)
      if syntaxer.repository
        RepoChecker.new(syntaxer).process
      else
        PlainChecker.new(syntaxer).process
      end
    end

    protected

    def check rule, file
      changed
      unless rule.exec_existence
        # notify if not exists
        notify_observers({:rule => rule})
      else
        if @syntaxer.warnings && rule.name == :ruby
          rule.exec_rule.exec_rule = rule.exec_rule.exec_rule.gsub(/(-\S+)\s/,'\1w ')
        end
        errors = rule.exec_rule.run(file)
        FileStatus.build(file, errors)
        notify_observers({:file_status => errors.empty?})
      end
    end

  end

  # Check status of files in repository

  class RepoChecker < Checker

    def initialize syntaxer
      super syntaxer, syntaxer.repository.changed_and_added_files.length
    end

    # Check syntax in repository directory
    #
    # @see Checker#process

    def process
      rule_files = {}
      @deferred_process = []
      @reader.rules.each do |rule|
        rule_files[rule.name] = {}
        rule_files[rule.name][:rule] = rule
        rule_files[rule.name][:files] = []
        rule.extensions.each do |ext|
          files.each do |file|
            if File.extname(file).gsub(/\./,'') == ext || \
              (!rule.specific_files.nil? && !rule_files[rule.name][:files].include?(file) && rule.specific_files.include?(file))
              rule_files[rule.name][:files].push(file)
            end
          end
        end
      end

      rule_files.each do |rule_name, rule|
        if rule[:rule].deferred
          @deferred_process << rule[:rule]
        else
          rule[:files].each do |file|
            full_path = File.join(@syntaxer.root_path,file)
            check(rule[:rule], full_path)
          end
        end
      end

      @deferred_process.each do |rule|
        rule.exec_rule.run
      end

      self
    end

    private
    def files
      @syntaxer.repository.changed_and_added_files
    end
  end

  class PlainChecker < Checker

    def initialize syntaxer
      super syntaxer, syntaxer.reader.files_count(syntaxer)
    end

    # Check syntax in indicated directory
    #
    # @see Checker#process

    def process
      @deferred_process = []
      @reader.rules.each do |rule|
        if rule.deferred
          @deferred_process << rule
        else
          # check if executor exists
          rule.files_list(@syntaxer.root_path).each do |file|
            check(rule, file)
          end
        end
      end
      
      @deferred_process.each do |rule|
        rule.exec_rule.run
      end
      
      self
    end

  end
  
end
