require 'jslint'

module Syntaxer
  class Runner
    include Open3

    attr_accessor :rule, :exec_rule, :condition_var

    def initialize rule = nil, exec_rule = nil
      @rule, @exec_rule = rule, exec_rule
    end

    class << self
      def javascript
        lambda do |rule|
          c = Syntaxer::Runner.new(rule)
          c.extend(Runners::Javascript)
          c
        end
      end

      def default rule, exec_rule
        c = self.new(rule, exec_rule)
        c.extend(Runners::Default)
        c
      end
    end
  end

  module Runners
    
    module Default
      def run file
        result = popen3(@exec_rule.gsub('%filename%', file)) do |stdin, stdout, stderr, wait_thr|
          stderr.read.split("\n")
        end
        result
      end
    end

    module Javascript
      def run(root, files = [])
        puts ''
        JSLint::Lint.new(
                         :paths => files,
                         :config_path => 'config/jslint.yml'
                         ).run
        []
      rescue JSLint::LintCheckFailure
        $stdmyout.puts "jslint checking failed".color(:red)
      end
    end

  end

end
