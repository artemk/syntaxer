module Syntaxer
  module Runner
    class CommandLine
    
      class << self
        
        def run(stdout = $stdout, stderr = $stderr)
          argv = @argv || ARGV
          options = Syntaxer::Runner::OptionParser.parse(argv, stdout, stderr)
          Syntaxer.setup(options)
          Proc.new{return Syntaxer::Runner.wizzard(options)}.call if options.run_wizzard?
          Proc.new{return Syntaxer::Runner.make_hook(options)}.call if options.run_make_hook?
          Proc.new{return Syntaxer::Runner.check_syntax(options)}.call if options.run_check_syntax?
          1
        end
        
      end
      
    end
  end
end
