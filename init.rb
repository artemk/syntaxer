begin
  require File.join(File.dirname(__FILE__), 'lib', 'syntaxer') # From here
rescue LoadError
  require 'syntaxer' # From gem
end
