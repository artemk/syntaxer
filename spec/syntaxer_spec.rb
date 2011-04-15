require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer" do
  subject {Syntaxer}
  
  it {should respond_to(:check_syntax)}

  context "in plain mode" do
    it "should exit with error if where is syntax mistake" do
      lambda{ subject.check_syntax({:root_path => fixtures_path, :config_file => syntaxer_rules_example_file}) }.should raise_exception
    end
  end

  context "checking GIT repo" do
    
    before(:each) do
      @repo_dir = create_temp_ruby_project
      make_initial_commit(@repo_dir)
    end
    
    it "should exit with error if there are files whith errors" do
      add_file_to_repo(:ruby, @repo_dir, "correct.rb.example")
      add_file_to_repo(:ruby, @repo_dir, "wrong.rb.example")
      make_git_add(@repo_dir)
      add_hook @repo_dir
      g = Git.open(Dir.new(@repo_dir))
      g.chdir do
        lambda {g.commit('second commit')}.should raise_exception
      end
    end

    it "should commit if there are no errors in files" do
      add_file_to_repo(:ruby, @repo_dir, "correct.rb.example")
      make_git_add(@repo_dir)
      add_hook @repo_dir
      g = Git.open(Dir.new(@repo_dir))
      g.chdir do
        lambda {g.commit('second commit')}.should_not raise_exception
      end
    end

    after(:each) do
      FileUtils.rm_rf(@repo_dir)
    end
  end

end
