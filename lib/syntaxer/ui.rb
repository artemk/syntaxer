module Syntaxer
  class UI
    class << self

      attr_accessor :mode

      def setup options
        @mode = :quite if options.quite?
        @mode = :loud if options.loud?
      end

    end
  end
end
