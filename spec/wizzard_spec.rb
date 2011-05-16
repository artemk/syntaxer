require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Wizzard" do
  subject{Syntaxer::Wizzard}

  context "installation with non rails, non git project with no jslint" do

    before(:each) do
      @working_dir = create_temp_dir
      Dir.stub(:getwd){@working_dir}
      @options = Syntaxer::Runner::Options.new
      @options.config_path = @working_dir + '/config'
      @options.config_path_exists = false
      @options.create_config_dir = true
      @options.languages = [[:ruby, ['*/*', 'lib/*']]]
    end

    it "should create config file in config folder" do
      subject.new(@options).run
      FileTest.file?(File.join(@options.config_path, Syntaxer::SYNTAXER_CONFIG_FILE_NAME)).should be_true
    end

    it "should create valid config file" do
      subject.new(@options).run
      rules_tested = Syntaxer::Reader::DSLReader.load(File.join(@options.config_path, Syntaxer::SYNTAXER_CONFIG_FILE_NAME)).rules
      rules_original = Syntaxer::Reader::DSLReader.load(Syntaxer::SYNTAXER_RULES_FILE).rules
      
      ruby_rule_tested = rules_tested.find(:ruby)
      ruby_rule_tested.folders.should eql(@options.languages.first.last)

      ruby_rule_original = rules_original.find(:ruby)
      ruby_rule_tested.exec_rule.exec_rule.should eql(ruby_rule_original.exec_rule.exec_rule)
    end

    after(:each) do
      FileUtils.rm_r(@working_dir)
    end
    
  end

  context "installation with rails, git and jslint" do

    before(:each) do
      Kernel.stub(:system)
      @working_dir = create_temp_ruby_project
      Dir.stub(:getwd){@working_dir}
      File.new(File.join(@working_dir,'README'),'w').close
      make_git_add(@working_dir)
      make_initial_commit(@working_dir)

      FileUtils.mkdir_p(File.join(@working_dir,'config'))
      File.new(File.join(@working_dir,'config','application.rb'),'w').close
      File.new(File.join(@working_dir,'config','routes.rb'),'w').close
      
      @options = Syntaxer::Runner::Options.new
      @options.rails = true
      @options.root_path = @working_dir
      @options.repository = :git
      @options.config_path = @working_dir + '/config'
      @options.languages = [[:ruby, Syntaxer::Wizzard::FOLDERS_RAILS[:ruby]], [:javascript, Syntaxer::Wizzard::FOLDERS_RAILS[:javascript]]]
      
    end

    it "should create config file in config folder" do
      subject.new(@options).run
      FileTest.file?(File.join(@working_dir,'config', Syntaxer::SYNTAXER_CONFIG_FILE_NAME)).should be_true
    end

    it "should create hook" do
      subject.new(@options).run
      FileTest.file?(File.join(@working_dir,'.git/hooks/pre-commit')).should be_true
    end

    it "should create valid .syntaxer file" do
      subject.new(@options).run
      syntaxer = File.open(File.join(@working_dir,'.syntaxer')).read
      hook = File.open(File.join(@working_dir,'.git/hooks/pre-commit')).read
      hook.include?(syntaxer).should be_true
    end

    it "should create valid config file" do
      subject.new(@options).run
      rules_tested = Syntaxer::Reader::DSLReader.load(File.join(@working_dir,'config', Syntaxer::SYNTAXER_CONFIG_FILE_NAME)).rules
      ruby_rule_tested = rules_tested.find(:ruby)
      ruby_rule_tested.folders.should eql(@options.languages.first.last)
    end

    it "should create jsling config file" do
      Kernel.should_receive(:system).once
      subject.new(@options).run
    end

    after(:each) do
      FileUtils.rm_r(@working_dir)
    end

  end

end
