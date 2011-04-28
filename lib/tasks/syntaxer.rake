namespace :syntaxer do
  desc 'Install syntaxer to rails project'
  task :install => :environment do
    if ARGV.any?{|a| a =~ /--jslint/} 
      Rake::Task['jslint:copy_config'].execute
      config_file = "syntaxer_rails_rules.dist.rb"
    else
      config_file = "syntaxer_rules.dist.rb"
    end

    FileUtils.cp(File.join(File.dirname(__FILE__),'..','..',config_file), File.join(Rails.root,'config','syntaxer.rb'))
    
    system('syntaxer -i -r git --rails')
    
    puts "Syntaxer hook installed. Look to the config/syntaxer.rb to change configuration.".color(:green)
  end
end
