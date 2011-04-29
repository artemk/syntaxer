require 'jslint'

module Syntaxer
  class Runner
    include Open3

    attr_accessor :rule, :exec_rule, :condition_var

    def initialize exec_rule = nil
      @exec_rule = exec_rule
    end

    class << self
      def javascript
        lambda do
          c = Syntaxer::Runner.new(rule)
          c.extend(Runners::Javascript)
          c
        end
      end

      def default exec_rule
        c = self.new(exec_rule)
        c.extend(Runners::Default)
        c
      end
    end
  end

  module Runners
    
    module Default
      def run file
        result = Open3.popen3(@exec_rule.gsub('%filename%', file)) do |stdin, stdout, stderr, wait_thr|
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
        $stdmyout.puts "jslint checking failed"
      end
    end

  end

end
