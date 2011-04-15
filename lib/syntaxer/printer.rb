require "rainbow"
module Syntaxer

  # Print system messages

  class Printer
    class << self
      attr_accessor :quite

      # Print progress in dot notation
      #
      # @param [Boolean] (true|false)

      def print_progress succ = true
        if succ
          s = '.'.color(:green)
        else
          s = 'E'.color(:red)
        end
        print s unless @quite
      end

      # Print error message for each if file
      #
      # @param [Array, #each] files

      def print_result files
        return if @quite
        puts "\n"
        puts "Syntax OK".color(:green) if files.empty?

        files.each do |file|
          puts file.file_name
          file.errors.each do |error|
            puts "\t #{error}".color(:red)
          end
        end
      end
    end
  end
end
