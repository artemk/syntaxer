namespace :syntaxer do
  desc 'Install syntaxer to rails project'
  task :install => :environment do
    if ARGV.any?{|a| a =~ /--jslint/} 
      Rake::Task['jslint:copy_config'].execute
      Syntaxer::Utils.write_rails_conf_with_jslint
    else
      Syntaxer::Utils.write_rails_conf_without_jslint
    end

    system('syntaxer -i -r git --rails')
    FileUtils.cp(File.join(File.dirname(__FILE__),'..','..','syntaxer_rails_rules.dist.rb'),\
                 File.join(Rails.root,'config','syntaxer.rb'))
    
    puts "Syntaxer hook installed. Look to the config/syntaxer.rb to change configuration.".color(:green)
  end
end
