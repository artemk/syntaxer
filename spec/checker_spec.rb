require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Checker" do

  context "Syntaxer::PlainChecker" do

    before(:each) do
      options = Syntaxer::Runner::OptionParser.parse([],$stdout, $stderr)
      options.root_path = fixtures_path(:ruby)
      reader = mock('Reader')
      reader.stub!(:rules).and_return([Syntaxer::LanguageDefinition.new(:ruby, ["rb.example", "rake"], ["Rakefile", "Thorfile"], ["**/*"], nil, Syntaxer::Runner.default("ruby -c %filename%"), "ruby", true)])
      reader.stub!(:files_count).and_return(3)

      Syntaxer::Printer.setup(options)
      
      Syntaxer::Runner.stub(:options){options}
      Syntaxer::Runner.stub(:reader){reader}
    end

    subject {Syntaxer::PlainChecker.new(Syntaxer::Runner)}
    
    it {should respond_to(:error_files)}
    it {should respond_to(:all_files)}
    
    it "should send to FileStatus" do
      Syntaxer::FileStatus.should_receive(:build).exactly(3).times
      subject.process      
    end

  end

  context "Syntaxer::RepoChecker" do

    before(:each) do
      @repo_dir = create_temp_ruby_project
      make_initial_commit(@repo_dir)
      add_file_to_repo(:ruby, @repo_dir, "correct.rb.example")
      add_file_to_repo(:ruby, @repo_dir, "wrong.rb.example")
      make_git_add(@repo_dir)

      options = Syntaxer::Runner::OptionParser.parse([],$stdout, $stderr)
      options.root_path = @repo_dir

      reader = mock('Reader')
      reader.stub!(:rules).and_return([Syntaxer::LanguageDefinition.new(:ruby, ["example", "rake"], ["Rakefile", "Thorfile"], ["**/*"], nil, Syntaxer::Runner.default("ruby -c %filename%"), "ruby", true)])      

      repository = Syntaxer::Repository.factory(options.root_path)

      Syntaxer::Printer.setup(options)

      Syntaxer::Runner.stub(:options){options}
      Syntaxer::Runner.stub(:reader){reader}
      Syntaxer::Runner.stub(:repository){repository}
    end

    subject {Syntaxer::RepoChecker.new(Syntaxer::Runner)}

    it "should return correct error_files" do
      subject.process
      subject.all_files.size.should_not eql(0)
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
