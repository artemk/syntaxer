require "rubygems"
require "rake"
require "open3"
require "forwardable"
require "git"
require "rainbow"
require 'progress_bar'
require File.join(%w{syntaxer reader})
require File.join(%w{syntaxer file_status})
require File.join(%w{syntaxer checker})
require File.join(%w{syntaxer runner})
require File.join(%w{syntaxer repository})
require File.join(%w{syntaxer language_definition})
require File.join(%w{syntaxer printer})
require File.join(%w{syntaxer progress_bar})

require File.join(%w{syntaxer railtie}) if defined?(Rails)

module Syntaxer
  DEFAULT_FILES_MASK = "**/*"
  SYNTAXER_RULES_FILE = File.join(File.dirname(__FILE__), "..", "syntaxer_rules.dist.rb")
  
  class << self
    attr_reader :reader, :repository, :root_path, :results, :warnings, :hook, :jslint
    
    def configure
      yield(self) if block_given?
    end
     
    # Main method to be used for syntax checking. 
    # 
    # @return [Boolean]
    #  
    # @param [Hash] options the options to perform syntax checking
    # @option options [String] :root_path (Dir.getwd) The starting point, which will be used for all relative path's
    # @option options [String] :languages (:all) Type of languages to be used in checking
    # @option options [String] :repository (git|svn) Type of repository
    # @option options [String] :config_file(SYNTAXER_RULES_FILE) File with syntax rules and language definitions
    
    def check_syntax(options = {})
      @root_path = options[:root_path]
      @warnings = options[:warnings]
      @hook = options[:hook]
      @jslint = options[:jslint]
      Printer.quite = options[:quite] || false
      Printer.loud = options[:loud] || false
      
      @reader = Reader::DSLReader.load(options[:config_file])

      if @jslint # if jslint option passed set from command line we have to add new rule with indicated dir
        rule = LanguageDefinition.new(:javascript, %w{js}, nil, [@jslint+"*", @jslint+"**/*"], nil, nil, nil, true, true)
        rule.exec_rule = Runner.javascript.call(rule)
        @reader.add_rule rule
      end

      @repository = Repository.factory(@root_path, options[:repository]) if options[:repository]

      $stdmyout = StringIO.new
      checker = Checker.process(self)
      Printer.print_result checker

      exit(1) unless checker.error_files.empty? && $stdmyout.string.empty?
    end

    # This method generate and put hook to .git/hooks
    #
    # @return [Nil]
    #
    # @see Syntaxer#check_syntax
    # @raise ArgumentError if no repository indicated
    # @raise ArgumentError if SVN is indicated. SVN is not supported yet.

    def make_hook(options)
      @root_path = options[:root_path]
      raise ArgumentError, 'Indicate repository type' unless options.include?(:repository)
      raise ArgumentError, "SVN is temporarily not supported" if options[:repository].to_sym == :svn
      
      repo = Repository.factory(@root_path, options[:repository])
      hook_file = "#{@root_path}/.git/hooks/pre-commit"
      hook_string = "syntaxer -r git --hook"
      hook_string += " -c config/syntaxer.rb" if options[:rails]
      
      File.open(hook_file, 'w') do |f|
        f.puts hook_string
      end
      File.chmod(0755, hook_file)
    rescue Exception => e
      puts e.message.color(:red)
      raise e
    end
    
  end
end
# 
# Syntaxer.configure do |config|
#   config.root = File.expand_path(File.dirname(__FILE__) + '../..')
# end
