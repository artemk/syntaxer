namespace :syntaxer do
  desc 'Install syntaxer to rails project'
  task :install => :environment do
    Syntaxer::Wizzard.start
  end
end
