syntaxer do

  languages :ruby do
    extensions "example"
    folders '**/*'
  end
  
  languages :haml do
    extensions "haml"
    folders '**/*'  
  end

  #ignore_folders "app/models/**" # this folders will be deleted from all languages
  
end
