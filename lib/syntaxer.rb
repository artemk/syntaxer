require "rubygems"
require "rake"
require "open3"
require "forwardable"
require "git"
require "rainbow"
require 'progress_bar'
require 'highline'
require "highline/import"
require File.join(%w{syntaxer version})
require File.join(%w{syntaxer railtie}) if defined?(Rails)

module Syntaxer
  DEFAULT_FILES_MASK = "**/*"
  SYNTAXER_RULES_FILE = File.join(File.dirname(__FILE__), "..", "syntaxer_rules.dist.rb")
  SYNTAXER_CONFIG_FILE_NAME = "syntaxer.rb"

  STATUS_SUCCESS = 0
  STATUS_FAIL = 1

  autoload :UI, "syntaxer/ui"
  autoload :Git, "syntaxer/repository"
  autoload :Runner, 'syntaxer/runner'
  autoload :Wizzard, 'syntaxer/wizzard'
  autoload :Checker, "syntaxer/checker"
  autoload :RepoChecker, "syntaxer/checker"
  autoload :PlainChecker, "syntaxer/checker"
  autoload :ProgressBar, "syntaxer/progress_bar"
  autoload :Reader, "syntaxer/reader"
  autoload :Writer, "syntaxer/writer"
  autoload :Repository, "syntaxer/repository"
  autoload :Printer, "syntaxer/printer"
  autoload :FileStatus, "syntaxer/file_status"
  autoload :Repository, "syntaxer/repository"
  autoload :LanguageDefinition, "syntaxer/language_definition"
  autoload :LanguageRules, "syntaxer/language_definition"

  class << self
    attr_reader :options
    
    def setup options
      @options = options
      UI.setup(@options)
      Printer.setup(@options)
    end

  end
end
