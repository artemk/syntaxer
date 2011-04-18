require "rainbow"
module Syntaxer

  # Print system messages

  class Printer
    class << self
      @@bar = nil
      attr_accessor :quite

      # Set count of files for progress bar
      #
      # @param [Integer] count of files

      def count_of_files count
        @@bar = ProgressBar.new(count, :bar, :counter)
      end

      # Show progress
      #
      # @param [Boolean] (true|false)

      def update status
        @@bar.increment! unless @quite
      end

      # Print error message for each if file
      #
      # @param [Array, #each] files

      def print_result files
        return if @quite
        puts "\n"
        puts "Syntax OK".color(:green) if files.empty?
        puts "Errors:".color(:red) unless files.empty?

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
