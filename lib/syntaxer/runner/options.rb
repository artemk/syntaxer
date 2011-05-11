module Syntaxer
  module Runner
    class Options
      include Syntaxer::Runner::OptDefinition

      flag_opt :loud
      flag_opt :quite
      flag_opt :warnings
      flag_opt :rails
      
      data_opt :config_file, Syntaxer::SYNTAXER_RULES_FILE
      data_opt :root_path, Dir.getwd
      data_opt :repository, :git

      action_opt :wizzard
      action_opt :restore
      action_opt :jslint
      action_opt :make_hook
      action_opt :check_syntax, true

      def no_actions?
        @default_action.nil?
      end
    end

  end
end
