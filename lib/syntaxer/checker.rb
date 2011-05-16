require 'set'
require "observer"
require 'thread'
module Syntaxer
  class Checker
    include Observable
    extend Forwardable

    def_delegators Syntaxer::FileStatus, :error_files, :all_files
    
    attr_accessor :runner, :reader
    
    def initialize(runner, count)
      Printer.count_of_files = count
      add_observer(Printer)
      @runner = runner
      @reader = @runner.reader
      @results = []
    end

    # Factory for checker
    #
    # @return [RepoChecker, #process] 

    def self.process(runner)
      if runner.options.repository?
        RepoChecker.new(runner).process
      else
        PlainChecker.new(runner).process
      end
    end

    protected

    def check rule, file
      changed
      unless rule.exec_existence
        # notify if not exists
        notify_observers({:rule => rule})
      else
        if @runner.options.warnings? && rule.name == :ruby
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

    def initialize runner
      @runner = runner
      count_of_files = 0
      @rule_files = {}
      @deferred_process = []
      runner.reader.rules.each do |rule|
        @rule_files[rule.name] = {}
        @rule_files[rule.name][:rule] = rule
        @rule_files[rule.name][:files] = []
        rule.extensions.each do |ext|
          files.each do |file|
            if File.extname(file).gsub(/\./,'') == ext || 
              (!rule.specific_files.nil? && !@rule_files[rule.name][:files].include?(file) && rule.specific_files.include?(file))
            then
              @rule_files[rule.name][:files].push(file)
              count_of_files += 1 if !rule.deferred # skip these files
            end
          end
        end
      end

      super runner, count_of_files 
    end

    # Check syntax in repository directory
    #
    # @see Checker#process

    def process
      @rule_files.each do |rule_name, rule|
        if rule[:rule].deferred
          @deferred_process << rule
        else
          rule[:files].each do |file|
            full_path = File.join(@runner.options.root_path,file)
            check(rule[:rule], full_path)
          end
        end
      end

      @deferred_process.each do |rule|
        rule[:rule].exec_rule.run(@runner.options.root_path, rule[:files])
      end

      self
    end

    private
    def files
      @runner.repository.changed_and_added_files
    end
  end

  class PlainChecker < Checker

    def initialize runner
      super runner, runner.reader.files_count(runner)
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
          rule.files_list(@runner.options.root_path).each do |file|
            check(rule, file)
          end
        end
      end
      
      @deferred_process.each do |rule|
        rule.exec_rule.run(@runner.options.root_path, rule.files_list(@runner.options.root_path))
      end
      
      self
    end

  end
  
end
