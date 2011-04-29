module Syntaxer

  # Print system messages

  class Printer
    class << self
      NON_EXISTENT_RULE_MESSAGE = "exec_rule `%s` for language %s not exists. Skip"
      
      @@bar = nil
      @@not_exists_rules = []
      attr_accessor :quite, :loud, :mode, :count_of_files

      def setup &block
        yield self if block_given?
        if @mode == :hook
          @@bar = Syntaxer::ProgressBar.new
        else
          @@bar = ::ProgressBar.new(@count_of_files, :bar, :counter)
        end
      end

      # Show progress
      #
      # @param [Boolean] (true|false)

      def update *args #not_exists_rule = nil, file_status = (status=true;)
        args = args.first
        @@not_exists_rules << args[:rule] if args.include?(:rule) && !@@not_exists_rules.include?(args[:rule])
        return if @quite
        if args.include?(:file_status)
          @mode == :hook ? @@bar.increment!(args[:file_status]) : @@bar.increment!
        end
        true
      end

      # Print error message for each if file
      #
      # @param [Array, #each] files

      def print_result checker
        return if @quite
        puts "\n"
        puts "Syntax OK".color(:green) if checker.error_files.empty? && $stdmyout.string.empty?

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
        
        $stderr.puts("\nErrors:"+"\n\t"+$stdmyout.string.color(:red)) unless $stdmyout.string.empty?
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
