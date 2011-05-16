module Syntaxer
  module Runner
    class Options
      include Syntaxer::Runner::OptDefinition

      # General options
      flag_opt :loud
      flag_opt :quite
      flag_opt :warnings
      flag_opt :rails
      flag_opt :hook
      flag_opt :repository
      
      data_opt :config_file, Syntaxer::SYNTAXER_RULES_FILE
      data_opt :root_path, Dir.getwd
      data_opt :jslint, '.'

      action_opt :wizzard
      action_opt :restore
      action_opt :make_hook
      action_opt :check_syntax, true

      # Wizzard options
      data_opt :languages, []
      data_opt :config_path
      flag_opt :config_path_exists
      flag_opt :create_config_dir
      flag_opt :restore

      def no_actions?
        @default_action.nil?
      end
    end

  end
end
