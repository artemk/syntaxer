require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Syntaxer::Repository" do
  context "Git" do
    it "should not raise exception if there are no any revision" do
      @repo_dir = create_temp_ruby_project
      add_file_to_repo(:ruby, @repo_dir, 'wrong.rb.example')
      lambda{Syntaxer::Git.new(@repo_dir)}.should_not raise_exception
      FileUtils.rm_rf(@repo_dir)
    end
  end
end
