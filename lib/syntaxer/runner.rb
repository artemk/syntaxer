require 'jslint'

module Syntaxer
  module Runner

    autoload :OptionParser, 'syntaxer/runner/option_parser'
    autoload :OptDefinition, 'syntaxer/runner/opt_definition'
    autoload :Options, 'syntaxer/runner/options'
    autoload :CommandLine, 'syntaxer/runner/command_line'
    autoload :ExecRule, "syntaxer/runner/exec_rule"
    
  
    class << self
      attr_reader :options, :reader, :repository

      extend Forwardable
      def_delegators ExecRule, :javascript, :default
      
      # Main method to be used for syntax checking. 
      # 
      # @return [Boolean]
      #  
      # @param [Hash] options the options to perform syntax checking
      # @option options [String] :root_path (Dir.getwd) The starting point, which will be used for all relative path's
      # @option options [String] :languages (:all) Type of languages to be used in checking
      # @option options [String] :repository git Type of repository
      # @option options [String] :config_file(SYNTAXER_RULES_FILE) File with syntax rules and language definitions
      
      def check_syntax options
        @options = options
        @reader = Reader::DSLReader.load(options.config_file)
  
        if @options.jslint? # if jslint option passed set from command line we have to add new rule with indicated dir
          rule = LanguageDefinition.new(:javascript, %w{js}, nil, [@options.jslint+"*", @options.jslint+"**/*"], nil, nil, nil, true, true)
          rule.exec_rule = Runner.javascript.call
          @reader.add_rule rule
        end
  
        @repository = Repository.factory(@options.root_path, @options.repository) if @options.repository?
  
        $stdmyout = StringIO.new
        checker = Checker.process(self)
        Printer.print_result checker
  
        exit(STATUS_FAIL) unless checker.error_files.empty? && $stdmyout.string.empty?
        STATUS_SUCCESS
      end
  
      # This method generate and put hook to .git/hooks
      #
      # @return [Nil]
      #
      # @see Syntaxer#check_syntax
      # @raise ArgumentError if no repository indicated
      # @raise ArgumentError if SVN is indicated. SVN is not supported yet.
  
      def make_hook(options)
        @root_path = options.root_path
        raise ArgumentError, 'Indicate repository type' unless options.repository?
  
        hook_file = "#{@root_path}/.git/hooks/pre-commit"
        hook_string = 'syntaxer '
        
        if options.restore? && File.exist?(File.join(@root_path,'.syntaxer'))
          hook_string += File.open(File.join(@root_path,'.syntaxer')).read
        else
          repo = Repository.factory(@root_path)
          hook_string += "-r git --hook"
          hook_string += " -c config/syntaxer.rb" if options.rails?
          hook_string += " -c #{options.config_file}" unless options.config_file?
        end
        
        File.open(hook_file, 'w') do |f|
          f.puts hook_string
        end
        File.chmod(0755, hook_file)
  
        # save syntaxer options
        File.open(File.join(options.root_path,'.syntaxer'), 'w') do |f|
          f.write(hook_string.gsub('syntaxer ',''))
        end
  
      rescue Exception => e
        puts e.message.color(:red)
        raise e
      end
  
      def wizzard(options)
        Wizzard.start
      end
      
    end
  
  end
end
