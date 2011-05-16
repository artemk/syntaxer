module Syntaxer
  class UI
    class << self

      attr_accessor :mode

      def setup options, stdout = $stdout
        @mode = :quite if options.quite?
        @mode = :loud if options.loud?
        @stdout = stdout
        @opts = {:before_nl => false, :after_nl => true, :color => nil, :tab => false}
      end

      def info(message, opt = {})
        print(message, opt)
      end

      def message(message, opt={})
        print("#{message}".color(:green), opt)
      end

      def alert(message, opt = {})
        print("#{message}".color(:yellow), opt)
      end

      def warning(message, opt = {})
        print("#{message}".color(:red), opt)
      end

      def error(message, opt = {})
        print("#{message}".color(:red), opt, $stderr)
      end

      private
      def print(message, opt = {}, stdout = @stdout)
        opt = @opts.update(opt)
        message = "#{message}" if opt[:tab]
        message = "\n#{message}" if opt[:before_nl] 
        message = "#{message}\n" if opt[:after_nl]
        message = "#{message}".color(opt[:color]) unless opt[:color].nil?
        stdout.print(message)
        stdout.flush
      end

    end
  end
end
