require 'optparse'
module Syntaxer
  module Runner
    class OptionParser < ::OptionParser

      attr_accessor :stdout, :stderr, :options

      class << self
        
        def parse(args, stdout, stderr)
          parser = new
          parser.stdout = stdout
          parser.stderr = stderr
          parser.parse!(args)
          opts = parser.options
          opts.check_syntax = true if opts.no_actions?
          opts
        end
        
      end

      OPTIONS = {
        :config   => ["-c", "--config [CONFIG_FILE]", String, "Syntax rules file to be used for syntaxer"],
        :path     => ["-p", "--path [DIR]", String, "If you want to check files not from current place"],
        :repo     => ["-r", "--repo", "Run with git"],
        :quite    => ["-q", "--quite", "Run in quite mode"],
        :loud     => ["-l", "--loud", "Run in loud mode"],
        :warnings => ["-w", "--warnings", "Turn warning messages on"],
        :generate => ["-g", "--generate", "Write hooks to git"],
        :hook     => ["-H", "--hook", "Use syntaxer in hook context"],
        :rails    => ["-R", "--rails", "Use syntaxer with rails"],
        :jslint   => ["-j", "--jslint [DIR]", String, "Run jslint"],
        :install  => ["-i", "--install", "Run wizzard"]
      }

      def initialize
        super
        @options = Options.new
        
        banner = "Usage: syntaxer [options]"
        separator ""
        separator "Specific options:"
                                
        on(*OPTIONS[:config])     {|config_file|  @options.config_file = config_file}
        on(*OPTIONS[:path])       {|path|         @options.root_path = path}
        on(*OPTIONS[:repo])       {|type|         @options.repository = true}
        on(*OPTIONS[:quite])      {|quite|        @options.quite = true}
        on(*OPTIONS[:loud])       {|loud|         @options.loud = true}
        on(*OPTIONS[:warnings])   {|warnings|     @options.warnings = true}
        on(*OPTIONS[:generate])   {|generate|     @options.make_hook = true}
        on(*OPTIONS[:hook])       {|hook|         @options.hook = true}
        on(*OPTIONS[:rails])      {|rails|        @options.rails = true}
        on(*OPTIONS[:jslint])     {|path|         @options.jslint = path}
        on(*OPTIONS[:install])    {|install|      @options.wizzard = true}

        separator ""
        separator "Common options:"

        on_tail("-h", "--help", "Show this message") {show_help}
        on_tail("--version", "Show version") {show_version}
      end

      def show_help
        @stdout.puts self
        exit 1
      end

      def show_version
        puts Syntaxer::VERSION
        exit
      end

    end
  end
end
