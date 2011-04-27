module Syntaxer
  class Utils
    class << self
      
      def write_rails_conf_without_jslint
        FileUtils.cp(File.join(File.dirname(__FILE__),'..','..','syntaxer_rails_rules.dist.rb'),\
                     File.join(Rails.root,'config','syntaxer.rb'))
      end

      def write_rails_conf_with_jslint
      end

    end
  end
end
