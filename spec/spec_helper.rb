$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'rspec'
require 'git'
require 'syntaxer'
require "tmpdir"
require 'aruba/api'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}


ROOT = File.join(File.dirname(__FILE__), '..')

def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = old_verbose
end

def create_temp_git_repo
  @dir = Dir.tmpdir + "/#{Time.now.to_i}" + "/git_repo"
  FileUtils.mkdir_p(@dir)
  return @dir
end
  
def create_temp_ruby_project
  @ruby_repo_dir ||= create_temp_git_repo
  Git.init(@ruby_repo_dir)
  @ruby_repo_dir
end

def add_file_to_repo(lang, repo_dir, file_name)
  FileUtils.mkdir_p(File.join(repo_dir,lang.to_s))
  FileUtils.cp(File.join(fixtures_path, lang.to_s, file_name),File.join(repo_dir,lang.to_s,file_name))
end

def make_git_add(ruby_repo_dir)
  g = Git.open(File.expand_path(ruby_repo_dir))
  
  g.chdir do
    g.add('.')
  end
end

def make_initial_commit(ruby_repo_dir)
  g = Git.open(File.expand_path(ruby_repo_dir))
  FileUtils.touch(File.join(ruby_repo_dir, 'README'))
  
  make_git_add(ruby_repo_dir)
  g.commit('first commit')
  
end

def make_commit(ruby_repo_dir)
  g = Git.open(File.expand_path(ruby_repo_dir))
  
  g.chdir do
    g.commit('second commit')
  end
  
end

def add_hook(ruby_repo_dir)
  bin_file = File.join(ROOT,'bin', 'syntaxer')  
  hook_file = File.join(ruby_repo_dir,'.git/hooks/pre-commit')
  
  File.open(hook_file, 'w') do |f|
    f.puts "#{bin_file} -c #{syntaxer_rules_example_file('syntaxer_rules_git')} -r git -p #{ruby_repo_dir}"
  end
  
  File.chmod(0755, hook_file)
end

def fixtures_path(lang = nil)
  p = File.join(File.dirname(__FILE__), 'fixtures')
  p = File.join(p, lang.to_s) if lang
  p
end

def syntaxer_rules_example_file file = ''
  File.join(fixtures_path, "#{file.empty? ? 'syntaxer_rules': file}.rb" )
end

class ArubaHelper
  include Aruba::Api
  class << self
    def method_missing method, *args
      ArubaHelper.new.send(method, *args)
    end
  end
end

