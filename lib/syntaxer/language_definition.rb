module Syntaxer
  class LanguageDefinitionException < Exception; end
    
  LanguageDefinition = Struct.new(:name, :extensions, :specific_files, :folders, :ignore_folders, :exec_rule, :executor, :exec_existence, :deferred) do
    def initialize(*args)
      super(*args)
      raise LanguageDefinitionException.new "name can't be blank" unless self.name     
    end
    
    
    def files_list(root_path)
      root_path += "/" if root_path.match(/\/$/).nil?
      raise LanguageDefinitionException, "No extensions specified" if extensions.nil?
      main_rule = folders.map{|f| root_path + f + ".\{#{extensions.join(',')}\}"}
      list = Rake::FileList.new(main_rule) do |fl|              
        fl.exclude(ignore_folders) if ignore_folders
      end
      all_files = Rake::FileList.new(root_path+'*')
      list += all_files.find_all {|f| f if !File.directory?(f) && !specific_files.nil? && specific_files.include?(File.basename(f)) }
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
