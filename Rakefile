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

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
