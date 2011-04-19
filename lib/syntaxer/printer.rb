module Syntaxer

  # Print system messages

  class Printer
    class << self
      @@bar = nil
      @@all_files = []
      attr_accessor :quite, :verbose

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

      def print_result checker
        return if @quite
        puts "\n"
        puts "Syntax OK".color(:green) if checker.error_files.empty?

        @verbose ? (files = checker.all_files) : (files = checker.error_files)
        files.each do |file|
          print_message(file)
        end
      end

      def print_message filestatus
        return if @quite
        puts "\n"
        print filestatus.file_name
        puts " OK".color(:green) if filestatus.status == :ok && @verbose
        puts "\nErrors:".color(:red) if filestatus.status == :failed
        filestatus.errors.each do |error|
          puts "\t #{error}".color(:red)
        end
      end

    end
  end
end
