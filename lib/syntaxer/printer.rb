module Syntaxer

  # Print system messages

  class Printer
    class << self

      NON_EXISTENT_RULE_MESSAGE = "exec_rule `%s` for language %s not exists. Skip"
      
      @@bar = nil
      @@not_exists_rules = []
      @@options = nil

      def setup(options)
        @@options = options
      end

      def count_of_files=(count)
        if @@options.hook?
          @@bar = Syntaxer::ProgressBar.new
        else
          @@bar = ::ProgressBar.new(count, :bar, :counter)
        end
      end

      # Show progress
      #
      # @param [Boolean] (true|false)

      def update *args #not_exists_rule = nil, file_status = (status=true;)
        args = args.first
        @@not_exists_rules << args[:rule] if args.include?(:rule) && !@@not_exists_rules.include?(args[:rule])
        return if @@options.quite?
        if args.include?(:file_status)
          @@options.hook? ? @@bar.increment!(args[:file_status]) : @@bar.increment!
        end
        true
      end

      # Print error message for each if file
      #
      # @param [Array, #each] files

      def print_result checker
        return if @@options.quite?
        UI.message("Syntax OK") if checker.error_files.empty? && $stdmyout.string.empty?

        @loud ? (files = checker.all_files) : (files = checker.error_files)
        files.each do |file|
          print_message(file)
        end
        
        unless @@not_exists_rules.empty?
          @@not_exists_rules.each do |rule|
            UI.alert(NON_EXISTENT_RULE_MESSAGE % [rule.executor, rule.name], :before_nl => true)
          end
        end
        
        UI.error("\nErrors:"+"\n\t"+$stdmyout.string) unless $stdmyout.string.empty?
      end

      def print_message filestatus
        return if @@options.quite?
        UI.info(filestatus.file_name, :after_nl => false)
        UI.message("OK", :tab => true) if filestatus.status == :ok && @@options.loud?

        UI.warning("Errors", :before_nl => true) if filestatus.status == :failed
        filestatus.errors.each do |error|
          UI.warning(error, :tab => true)
        end
        UI.info("\r")
      end

    end
  end
end
