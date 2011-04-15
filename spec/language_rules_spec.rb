require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "LanguageRules" do
  before(:each) do
    @rules = Syntaxer::LanguageRules.new
  end
  
  it "should raise exception if obj is not LanguageDefinition instance" do
    lambda do 
       @rules << "a"
    end.should raise_exception(Syntaxer::LanguageDefinitionException)
  end
  
  it "should not raise if LanguageDefinition object added" do
    lambda do 
       @rules << Syntaxer::LanguageDefinition.new(:ruby)
    end.should_not raise_exception(Syntaxer::LanguageDefinitionException)
  end
  
  context "LanguageDefinition" do
    it "should not create w/o name" do
      lambda do 
         Syntaxer::LanguageDefinition.new
      end.should raise_exception(Syntaxer::LanguageDefinitionException)
    end    
  end
  
  context "LanguageDefinition" do
    it "#file_list should return correct file list based on rules" do
      correct_array = Rake::FileList.new(File.dirname(__FILE__) + '/fixtures/ruby/*')
      ld = Syntaxer::LanguageDefinition.new(:ruby, ["rb.example", "rake"], ["Rakefile", "Thorfile"], ["**/*"], nil, "`ruby -wc %filename%`")
      ld.files_list(File.dirname(__FILE__) + '/fixtures/').should == correct_array
    end
  end
  
end
