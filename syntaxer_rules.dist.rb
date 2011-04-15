syntaxer do    
  languages :ruby do
    folders "**/*"
    extensions "rb", "rake"
    specific_files "Rakefile", "Thorfile"
    exec_rule "ruby -wc %filename%"
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
end
