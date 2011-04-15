require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Checker" do

  context "Syntaxer::PlainChecker" do
    
    before(:each) do
      reader = mock('Reader')
      reader.stub!(:rules).and_return([Syntaxer::LanguageDefinition.new(:ruby, ["rb.example", "rake"], ["Rakefile", "Thorfile"], ["**/*"], nil, "ruby -wc %filename%")])
      Syntaxer.should_receive(:reader).and_return(reader)
      Syntaxer.stub!(:root_path).and_return(fixtures_path(:ruby))

      Syntaxer::Printer.stub!(:print_result)
      Syntaxer::Printer.stub!(:print_progress)
    end
    
    subject {Syntaxer::PlainChecker.new(Syntaxer)}
    
    it {should respond_to(:error_files)}
    it {should respond_to(:fine_files)}

    it "should return correct error_files " do
      subject.process
      subject.fine_files.size.should == 1      
      subject.error_files.size.should == 1
    end
    
    it "should send to FileStatus" do
      Syntaxer::FileStatus.should_receive(:build).twice
      subject.process      
    end
  end
  
  # it "fails" do
  #   fail "hey buddy, you should probably rename this file and start specing for real"
  # end

  context "Syntaxer::RepoChecker" do

    before(:all) do
      Syntaxer::Printer.stub!(:print_result)
      Syntaxer::Printer.stub!(:print_progress)
    end
    
    before(:each) do
      @repo_dir = create_temp_ruby_project
      make_initial_commit(@repo_dir)
      add_file_to_repo(:ruby, @repo_dir, "correct.rb.example")
      add_file_to_repo(:ruby, @repo_dir, "wrong.rb.example")
      make_git_add(@repo_dir)

      reader = mock('Reader')
      reader.stub!(:rules).and_return([Syntaxer::LanguageDefinition.new(:ruby, ["rb.example", "rake"], ["Rakefile", "Thorfile"], ["**/*"], nil, "ruby -wc %filename%")])
      Syntaxer.should_receive(:reader).and_return(reader)
      Syntaxer.stub!(:root_path).and_return(@repo_dir)
      repo = Syntaxer::Repository.factory(@repo_dir, :git)
      Syntaxer.stub!(:repository).and_return(repo)
    end
    
    subject {Syntaxer::RepoChecker.new(Syntaxer)}

    it "should return correct error_files" do
      subject.process
      subject.fine_files.size.should_not eql(0)
      subject.error_files.size.should_not eql(0)
    end

    it "should send to FileStatus" do
      Syntaxer::FileStatus.should_receive(:build).twice
      subject.process      
    end

    after(:each) do
      FileUtils.rm_rf(@repo_dir)
    end

  end
  

end
