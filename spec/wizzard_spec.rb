require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Wizzard" do
  subject{Syntaxer::Wizzard}

  context "installation of config to non rails project without git and no jslint" do

    before(:each) do
      @working_dir = create_temp_dir
      @options = {
        :rails => false,
        :git => false,
        :config_path => @working_dir,
        :config_path_exists => true,
        :languages => [[:ruby, ['*/*', 'lib/*']]]
      }
    end
    
    it "should create config" do
      subject.new(@options).run
      FileTest.file?(File.join(@working_dir, Syntaxer::SYNTAXER_CONFIG_FILE_NAME)).should be_true
      rules = Syntaxer::Reader::DSLReader.load(File.join(@working_dir, Syntaxer::SYNTAXER_CONFIG_FILE_NAME)).rules
      ruby_rule = rules.find(:ruby)
      ruby_rule.folders.should eql(@options[:languages].first.last)
    end

    after(:each) do
      FileUtils.rm_r(@working_dir)
    end
    
  end

  context "installation of config to rails project without git" do
    before(:each) do
      @working_dir = create_temp_dir
      @options = {
        :rails => true,
        :git => false,
        :config_path => @working_dir+"/config",
        :config_path_exists => true,
        :languages => [[:ruby, Syntaxer::Wizzard::FOLDERS_RAILS[:ruby]]]
      }
      FileUtils.mkdir_p(File.join(@working_dir,'config'))
      File.new(File.join(@working_dir,'config','application.rb'),'w').close
      File.new(File.join(@working_dir,'config','routes.rb'),'w').close
    end

    it "should install config for rails without errors" do
      subject.new(@options).run
      rules = Syntaxer::Reader::DSLReader.load(File.join(@working_dir, 'config', Syntaxer::SYNTAXER_CONFIG_FILE_NAME)).rules
      ruby_rules = rules.find(:ruby)
      ruby_rules.folders.should eql(@options[:languages].first.last)
    end
    
    after(:each) do
      FileUtils.rm_r(@working_dir)
    end

  end

  context "installation of config to rails with git" do
    before(:each) do
      repo_dir = create_temp_ruby_project
      @working_dir = repo_dir
      File.new(File.join(@working_dir,'README'),'w').close
      make_git_add(repo_dir)
      make_initial_commit(repo_dir)
      @options = {
        :rails => true,
        :root_path => repo_dir,
        :git => true,
        :config_path => @working_dir+"/config",
        :config_path_exists => true,
        :languages => [[:ruby, Syntaxer::Wizzard::FOLDERS_RAILS[:ruby]]]
      }
      FileUtils.mkdir_p(File.join(@working_dir,'config'))
      File.new(File.join(@working_dir,'config','application.rb'),'w').close
      File.new(File.join(@working_dir,'config','routes.rb'),'w').close
    end

    it "should install hook to git and create syntaxer config" do
      subject.new(@options).run
      rules = Syntaxer::Reader::DSLReader.load(File.join(@working_dir, 'config', Syntaxer::SYNTAXER_CONFIG_FILE_NAME)).rules
      ruby_rules = rules.find(:ruby)
      ruby_rules.folders.should eql(@options[:languages].first.last)
      FileTest.file?(File.join(@working_dir,'.git','hooks','pre-commit')).should be_true
    end

    after(:each) do
      FileUtils.rm_r(@working_dir)
    end

  end

end
