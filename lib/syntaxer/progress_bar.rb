module Syntaxer
  class ProgressBar
    
    def increment! status
      if status
        print ".".color(:green)
      else
        print "E".color(:red)
      end
    end
    
  end
end
