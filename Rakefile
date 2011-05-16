require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'syntaxer/version'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "syntaxer"
  gem.homepage = "http://github.com/artemk/syntaxer"
  gem.license = "MIT"
  gem.summary = "Syntax checker for ruby and other languages"
  gem.description = %Q{Syntax checker for ruby and other languages}
  gem.email = "kramarenko.artyom@gmail.com"
  gem.authors = ["artemk"]
  gem.executables = ["syntaxer"]
  gem.files.include "lib/syntaxer/progress_bar.rb"
  gem.version = Syntaxer::VERSION
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = Rake::FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

namespace :rcov do
  desc "Run all specs on multiple ruby versions (requires rvm)"
  task :portability do
    %w{1.8.7 1.9.2}.each do |version|
      system <<-BASH
        bash -c 'if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
                   source ~/.rvm/scripts/rvm;
                   rvm gemset list | grep syntaxer > /dev/null;
                   if [ $? -eq 1 ]; then
                     echo -e "\e[0;31m--------- Please run \033[4mrvm use #{version}@syntaxer --create; gem install bundler; bundle install;\033[0m\e[0;31m to create gemset for tests. Thanks. ----------\n\e[0m"
                     exit;
                   fi
                   rvm use #{version}@syntaxer;
                   echo -e "\e[0;33m--------- version #{version}@syntaxer ----------\n\e[0m";
                   rspec --color spec/*;
                   cucumber;
                 else
                   echo You have no rvm installed or it is installed not in home directory.
                 fi'
      BASH
    end
  end
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
