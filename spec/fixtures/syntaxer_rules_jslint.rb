syntaxer do

  languages :javascript do
    extensions "example"
    folders '**/*'
    exec_rule Syntaxer::Runner.javascript
  end
  
end
