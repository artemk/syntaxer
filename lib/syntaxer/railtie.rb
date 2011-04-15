require 'syntaxer'

module Syntaxer
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/syntaxer.rake"
      end
    end
  end
end