# @author Artyom Kramarenko
module Syntaxer
  module Reader
    DSLFileNotFoundError = Class.new(Exception)
    DSLError = Class.new(Exception)
    DSLSyntaxError = Class.new(DSLError)
        
    class DSLReader

      attr_reader :rules, :ignored_folders
      
      def initialize
        @rules = LanguageRules.new
        @ignore_folders = []
      end

      def add_rule rule
        @rules << rule
        self
      end

      # Calculate count of files in plain mode
      #
      # @param [Syntaxer] Syntaxer
      def files_count runner
        @rules.map{ |rule|
          if rule.deferred
            0 # skip such files
          else
            rule.files_list(runner.options.root_path).length
          end
        }.inject(:+)
      end
            
      class << self
        
        # Read files from params and send to {#parse} method to fill in {Syntaxer::LanguageDefinition LanguageDefinition} objects.
        # 
        # @param [Array] dsl_files    Files with syntaxer rules and language definitions to be used in syntax checking
        #
        # @return [DSLReader] reader object
        #
        # @raise [DSLFileNotFoundError] If file with file is not exists
        def load(*dsl_files)
          reader = build(dsl_files.empty? ? false : true)
          dsl_files = [dsl_files].flatten
          dsl_files.each do |file|
            begin
              reader.parse(File.read(file))
            rescue SystemCallError
              raise ::Syntaxer::Reader::DSLFileNotFoundError, "Error reading syntaxer rules file with path '#{file}'!  Please ensure it exists and that it is accessible."
            end
          end
          reader
        end
        
        def build(skip_default_rules = false, default_rules_file = SYNTAXER_RULES_FILE)
          reader = new
          reader.parse(File.read(default_rules_file)) unless skip_default_rules
          reader
        end
      end
      
      # Parses a syntaxer DSL specification from the string given.
      # 
      # @param [String] dsl_data     Text of actual data to be parsed
      #
      # @raise [DSLSyntaxError] If errors occur on parsing
      # @example
      #   Syntaxer::Reader::DSLReader.new.parse%|
      #     syntaxer do
      #       languages :ruby
      #         folders 'app/**/*', 'lib/**/*'
      #       end
      #     end
      #   | 
      def parse(dsl_data)
        self.instance_eval(dsl_data)
      rescue SyntaxError, NoMethodError, NameError => e
        raise DSLSyntaxError, "Illegal DSL syntax: #{e}"
      end
      
      # The top level block executor
      # 
      # @yield Description of block
      #
      # @example
      #     syntaxer do
      #       languages :ruby
      #         folders 'app/**/*', 'lib/**/*'
      #       end
      #     end
      def syntaxer(&block)
        self.instance_eval(&block)
      end
      
      # The languages block executor
      # 
      # @yield [langs_name] Description of block
      # @return [nil]
      #
      #
      # @example
      #    languages :ruby do
      #      folders 'app/**/*', 'lib/**/*'
      #    end
      # @see #syntaxer
      def languages(*args, &block)
        args.each do |lang|          
          @current_rule = @rules.find_or_create(lang)
          self.instance_eval(&block)
        end
      end
      
      # Stub for DSL folders method.
      #
      # @note This method won't check if files are really exist.
      #
      # @param [Array(String)] args   File regexps to be assigned for particular language
      #
      # @example
      #   folders('app/**/*', 'lib/**/*') #=> ['app/**/*', 'lib/**/*']
      #   folders() # => DEFAULT_FILES_MASK
      # @return [args]
      #      
      # @see #syntaxer
      def folders(*args)
        current_rule.folders = (args.empty? ? [DEFAULT_FILES_MASK] : args.flatten)
      end
      
      def extensions(*args)
        current_rule.extensions = args
      end
      
      def specific_files(*args)
        current_rule.specific_files = args
      end

      # Create exec rule for language. It may be console string and
      # ruby method
      #
      # @param [String|Proc]
      def exec_rule(exec_string)
        # if it is string create default console runner
        if !exec_string.respond_to?(:call) || exec_string.is_a?(String)
          current_rule.executor = exec_string.scan(/\w+/).first
          current_rule.exec_existence = system("which #{current_rule.executor} > /dev/null")
          exec_rule = Syntaxer::Runner::ExecRule.default(exec_string)
          current_rule.deferred = false
        else
          # if it is proc call it and pass current rule
          current_rule.exec_existence = true
          current_rule.deferred = true # we have run it after all console checkers
          exec_rule = exec_string.call
        end
        current_rule.exec_rule = exec_rule
      end
      
      def ignore_folders(ignore_folders)
        current_rule.ignore_folders = ignore_folders    
      end
      
      def overall_ignore_folders(*args)
        @ignored_folders = args
      end
      
      
      alias_method :ignore, :overall_ignore_folders
      alias_method :lang, :languages
      alias_method :f, :folders
      
      private
      def current_rule
        @current_rule
      end
    end #end of class DSLReader
    
    
  end #end of module Reader
end #end of module Syntaxer
