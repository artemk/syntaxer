module Syntaxer
  class LanguageDefinitionException < Exception; end
    
  LanguageDefinition = Struct.new(:name, :extensions, :specific_files, :folders, :ignore_folders, :exec_rule) do
    def initialize(*args)
      super(*args)      
      raise LanguageDefinitionException.new "name can't be blank" unless self.name     
    end
    
    
    def files_list(root_path)
      root_path += "/" if root_path.match(/\/$/).nil?
      main_rule = folders.map{|f| root_path + f + ".\{#{extensions.join(',')}\}"}
      list = Rake::FileList.new(main_rule) do |fl|              
        #fl.add(specific_files) if specific_files  TODO:fix this
        fl.exclude(ignore_folders) if ignore_folders
      end
      list
    end
  end
  
  
  class LanguageRules < Array

    def << (smth)
      raise LanguageDefinitionException.new "can't be other then LanguageDefinition class object" unless smth.is_a?(LanguageDefinition)
      super        
    end
    
    def find_or_create(name)
      found = find(name) 
      unless found
        found = LanguageDefinition.new(name)
        self << found
      end
      found
    end
    
    def find(name)
      self.detect{|ld| ld.name == name}
    end
  end
  
end
