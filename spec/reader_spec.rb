require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Reader::DSLReader" do
  
  context "#build" do
    it "should build from default distr rules files" do
      Syntaxer::Runner.stub(:default)

      @reader = Syntaxer::Reader::DSLReader.build
      @reader.rules.find(:ruby).should eql(Syntaxer::LanguageDefinition.new(:ruby, ["rb", "rake"], ["Rakefile", "Thorfile", "Gemfile"], ["**/*"], nil, Syntaxer::Runner.default("ruby -c %filename%"), "ruby", true, false))
      @reader.rules.find(:haml).should eql(Syntaxer::LanguageDefinition.new(:haml, ["haml"], nil, ["**/*"], nil, Syntaxer::Runner.default("haml -c %filename%"), "haml", system("which haml 2>&1 > /dev/null"), false))
      @reader.rules.find(:sass).should eql(Syntaxer::LanguageDefinition.new(:sass, ["sass"], nil, ["**/*"], nil, Syntaxer::Runner.default("sass -c %filename%"), "sass", system("which haml 2>&1 > /dev/null"), false))
      
    end
  end
  
  context "#parse" do
    
    it "should parse all languages" do
      reader = Syntaxer::Reader::DSLReader.new
      
      reader.parse %|
        syntaxer do
          languages :ruby do
            folders 'app/**/*', 'lib/**/*'
          end
          
          languages :haml do
            folders 'app/haml/**/*', 'lib/haml/**/*'
          end
        end
      |
      
      reader.rules.find(:ruby).folders.should == ['app/**/*', 'lib/**/*']
      reader.rules.find(:haml).folders.should == ["app/haml/**/*", "lib/haml/**/*"]      
    end
    
    it "should load from file" do
      reader = Syntaxer::Reader::DSLReader.load(syntaxer_rules_example_file)
      reader.rules.find(:ruby).folders.should == ["**/*"]
      reader.rules.find(:haml).folders.should == ["**/*"]     
    end
    
    it "should do substitution for the same rules" do
      reader = Syntaxer::Reader::DSLReader.build
      reader.rules.find(:ruby).folders.should == ["**/*"]
      
      reader.parse %|
        syntaxer do
          languages :ruby do
            folders 'app/**/*', 'lib/**/*'
          end
        end
      |
      
      reader.rules.find(:ruby).folders.should == ["app/**/*", "lib/**/*"]
      
    end
  end
  
  context "raise exceptions" do
    before(:each) do
      @reader = Syntaxer::Reader::DSLReader.new      
    end
    
    it "should raise exception if illegal formating of dsl file" do
      lambda do 
        @reader.parse %|
          syntaxer2 do
          end
        |
      end.should raise_exception(Syntaxer::Reader::DSLSyntaxError)
    end
  end
  
  context "#folders should change current_rule folders attr" do
    
    before(:each) do
      @reader = Syntaxer::Reader::DSLReader.new
      @current_rule = Syntaxer::LanguageDefinition.new(:name => :ruby)
      @reader.stub!(:current_rule).and_return(@current_rule)      
    end
    
    it "should return DEFAULT_FILES_MASK if no params given" do
      @reader.folders()
      @current_rule.folders.should == [Syntaxer::DEFAULT_FILES_MASK]
    end
    
    it "should return params back" do
      @reader.folders('app/**/*', 'app/lib/*')
      @current_rule.folders.should == ['app/**/*', 'app/lib/*']      
    end
        
    it "should change predefined folders" do
      old_files = "app/libs/bla/*"
      new_files = ['app/**/*', 'app/lib/*'] 
      @current_rule.folders = old_files
      @current_rule.folders.should == old_files   
      
      @reader.folders(new_files)
      @current_rule.folders.should == new_files    
    end
  end
  
  context "#overall_ignore_folders" do
    
    before(:each) do
      @reader = Syntaxer::Reader::DSLReader.new
    end
    
    it "should return DEFAULT_FILES_MASK if no params given" do
      @reader.overall_ignore_folders('app/**/*', 'app/lib/*').should == ['app/**/*', 'app/lib/*']
    end
    
    it "should return params back" do
      @reader.overall_ignore_folders().should == []
    end   
  end
    
end
