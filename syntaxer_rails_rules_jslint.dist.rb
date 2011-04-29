syntaxer do    
  languages :ruby do
    folders "app/*", "app/**/*", "lib/*", "lib/**/*"
    extensions "rb", "rake"
    specific_files "Rakefile", "Thorfile", "Gemfile"
    exec_rule "ruby -c %filename%"
  end
  
  lang :sass do
    folders "public/stylesheets/**/*"
    extensions "sass"
    exec_rule "sass -c %filename%"    
  end
  
  lang :haml do
    folders "app/views/**/*", "app/views/*"
    extensions "haml"
    exec_rule "haml -c %filename%"
  end

  lang :javascript do
    folders "public/javascripts/*", "public/javascripts/**/*"
    extensions "js"
    exec_rule Syntaxer::Runner.javascript
  end
end
