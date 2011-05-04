syntaxer do    
  languages :ruby do
    folders "**/*"
    extensions "rb", "rake"
    specific_files "Rakefile", "Thorfile", "Gemfile"
    exec_rule "ruby -c %filename%"
  end
  
  lang :sass do
    folders "**/*"
    extensions "sass"
    exec_rule "sass -c %filename%"    
  end
  
  lang :haml do
    folders "**/*"
    extensions "haml"
    exec_rule "haml -c %filename%"
  end

  lang :javascript do
    folders "**/*"
    extensions "js"
    exec_rule Syntaxer::Runner.javascript
  end
  
end
