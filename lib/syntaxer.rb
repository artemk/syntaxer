require "rubygems"
require "rake"
require "open3"
require "forwardable"
require "git"
require "rainbow"
require 'progress_bar'
require 'highline'
require "highline/import"
require File.join(%w{syntaxer reader})
require File.join(%w{syntaxer file_status})
require File.join(%w{syntaxer checker})
require File.join(%w{syntaxer runner})
require File.join(%w{syntaxer repository})
require File.join(%w{syntaxer language_definition})
require File.join(%w{syntaxer printer})
require File.join(%w{syntaxer progress_bar})
require File.join(%w{syntaxer wizzard})
require File.join(%w{syntaxer writer})

require File.join(%w{syntaxer railtie}) if defined?(Rails)

module Syntaxer
  DEFAULT_FILES_MASK = "**/*"
  SYNTAXER_RULES_FILE = File.join(File.dirname(__FILE__), "..", "syntaxer_rules.dist.rb")
  SYNTAXER_CONFIG_FILE_NAME = "syntaxer.rb"

  autoload :UI, "syntaxer/ui"
  autoload :Runner, 'syntaxer/runner'
  
end
# 
# Syntaxer.configure do |config|
#   config.root = File.expand_path(File.dirname(__FILE__) + '../..')
# end
