$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
pp File.join(File.dirname(__FILE__), '..', 'lib')
require 'aruba/cucumber'
require 'fileutils'
require "git"
require 'syntaxer'
require 'cucumber/rspec/doubles' 
