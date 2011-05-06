require 'syntaxer'

module Syntaxer
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      
      rake_tasks do
        load "tasks/syntaxer.rake"
      end

      initializer "syntaxer.initialize" do |app|
        if app.root.join('.syntaxer').exist? && !app.root.join('.git/hooks/pre-commit').exist? && Rails.env.development?
          Syntaxer.make_hook({:root_path => app.root, :repository => :git, :rails => true, :restore => true})
          puts "Syntaxer hook restored.".color(:green)
        end
      end

    end
  end
end
