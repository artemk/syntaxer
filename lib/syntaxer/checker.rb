#       Rake::FileList
require 'set'
module Syntaxer
  class Checker
    include Open3
    extend Forwardable

    # Does not working
    def_delegators Syntaxer::FileStatus, :error_files, :fine_files      
         
    attr_accessor :syntaxer, :reader

    # List of files with correct syntax
    #
    # @return [Array<FileStatus>, #each] array with files
    #
    # @see FileStatus#fine_files
    
    def self.fine_files
      FileStatus.fine_files
    end

    # List of files with wrong syntax
    #
    # @return [Array<FileStatus>, #each] array with files
    #
    # @see FileStatus#fine_files

    def self.error_files
      FileStatus.error_files
    end
    
    def initialize(syntaxer)
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
         
  end

  # Check status of files in repository

  class RepoChecker < Checker

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
          errors = nil
          full_path = File.join(@syntaxer.root_path,file)
          stdout, stderr, status = capture3(rule.exec_rule.gsub('%filename%', full_path))
          errors = stderr.split("\n")

          Printer.print_progress errors.empty?
          FileStatus.build(file, errors)
        end
      end
      FileStatus
    end

    private
    def files
      @syntaxer.repository.changed_and_added_files
    end
  end

  class PlainChecker < Checker

    # Check syntax in indicated directory
    #
    # @see Checker#process

    def process
      @reader.rules.each do |rule|
        rule.files_list(@syntaxer.root_path).each do |file|
          errors = nil
          stdout, stderr, status = capture3(rule.exec_rule.gsub('%filename%', file))
          errors = stderr.split("\n")
          
          Printer.print_progress errors.empty?
          FileStatus.build(file, errors)
        end
      end
      FileStatus
    end

  end
  
end
