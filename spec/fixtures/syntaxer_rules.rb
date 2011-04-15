syntaxer do

  languages :ruby do
    folders 'app/controllers/**/*'
  end
  
  languages :haml do
    folders 'app/views/**/*'  
  end

  #ignore_folders "app/models/**" # this folders will be deleted from all languages
  
end
