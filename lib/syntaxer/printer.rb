module Syntaxer

  # Print system messages

  class Printer
    class << self
      NON_EXISTENT_RULE_MESSAGE = "exec_rule `%s` for language %s not exists. Skip"
      
      @@bar = nil
      @@not_exists_rules = []
      attr_accessor :quite, :loud

      # Set count of files for progress bar
      #
      # @param [Integer] count of files

      def count_of_files count
        @@bar = ProgressBar.new(count, :bar, :counter)
      end

      # Show progress
      #
      # @param [Boolean] (true|false)

      def update not_exists_rule = nil
        @@bar.increment! if !@quite #&& not_exists_rule.nil?
        @@not_exists_rules << not_exists_rule if !not_exists_rule.nil? && !@@not_exists_rules.include?(not_exists_rule)
      end

      # Print error message for each if file
      #
      # @param [Array, #each] files

      def print_result checker
        return if @quite
        puts "\n"
        puts "Syntax OK".color(:green) if checker.error_files.empty?

        @loud ? (files = checker.all_files) : (files = checker.error_files)
        files.each do |file|
          print_message(file)
        end

        unless @@not_exists_rules.empty?
          puts "\n"
          @@not_exists_rules.each do |rule|
            puts (NON_EXISTENT_RULE_MESSAGE % [rule.executor, rule.name]).color(:yellow)
          end
        end
      end

      def print_message filestatus
        return if @quite
        puts "\n"
        print filestatus.file_name
        puts " OK".color(:green) if filestatus.status == :ok && @loud
        puts "\nErrors:".color(:red) if filestatus.status == :failed
        filestatus.errors.each do |error|
          puts "\t #{error}".color(:red)
        end
      end

    end
  end
end
