require 'set'
require "observer"
module Syntaxer
  class Checker
    include Open3
    include Observable
    extend Forwardable

    def_delegators Syntaxer::FileStatus, :error_files, :fine_files      
         
    attr_accessor :syntaxer, :reader
    
    def initialize(syntaxer, count)
      Printer.count_of_files count
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
      popen3(rule.exec_rule.gsub('%filename%', file)) do |stdin, stdout, stderr, wait_thr|
        stderr.read.split("\n")
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
      checked_files = Set.new
      @reader.rules.each do |rule|
        files_collection = []
        rule.extensions.each do |ext|
          files.each do |file|
            if file.include?(ext) && !checked_files.include?(file)
              files_collection << file
              checked_files.add(file)
            end
          end
        end

        files_collection.each do |file|
          full_path = File.join(@syntaxer.root_path,file)
          errors = check(rule, full_path)
          FileStatus.build(file, errors)
          changed
          notify_observers(errors.empty?)
        end
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
      @reader.rules.each do |rule|
        rule.files_list(@syntaxer.root_path).each do |file|
          errors = check(rule, file)
          FileStatus.build(file, errors)
          changed
          notify_observers(errors.empty?)
        end
      end
      
      self
    end

  end
  
end
