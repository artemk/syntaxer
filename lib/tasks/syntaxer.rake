namespace :syntaxer do
  desc 'my plugins rake task'
  task :install => :environment do
    system('syntaxer -i -r git --hook --rails')
    FileUtils.cp(File.join(File.dirname(__FILE__),'..','..','syntaxer_rails_rules.dist.rb'),\
                 File.join(Rails.root,'config','syntaxer.rb'))
    puts "Syntaxer hook installed. Look to the config/syntaxer.rb to change configuration.".color(:green)
  end
end
