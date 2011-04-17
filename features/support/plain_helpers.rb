module PlainHelpers
  SYNTAXER_ROOT_PATH = File.join(File.dirname(__FILE__), '..', '..')
  
  @tmp_dir
  def temp_dir
    tmpdir = File.expand_path current_dir
    @tmp_dir = tmpdir
    tmpdir
  end

  def add_fixtures_files
    Dir["#{fixtures_path}/*.example"].each do |f|
      FileUtils.cp f, File.join(@tmp_dir,File.basename(f,'.example'))
    end
  end
  
  def create_tmp_dir
    tmpdir = temp_dir
    create_dir(tmpdir)
    tmpdir
  end

  def syntaxer_rules_example_file file = ''
    File.join(File.expand_path('../../',File.dirname(__FILE__)), 'spec/fixtures', "#{file.empty? ? 'syntaxer_rules': file}.rb")
  end

  def create_tmp_repo_dir
  end
  
  def fixtures_path
    File.join(File.expand_path('../../',File.dirname(__FILE__)),'spec/fixtures/ruby')
  end
  
  def create_temp_plain_work_dir
    tmp = create_tmp_dir
    
    in_current_dir do
      add_fixtures_files
    end
    
  end

  def create_temp_repo_work_dir
    create_tmp_dir
    
    g = Git.init(File.expand_path(File.join(@tmp_dir)))    
    FileUtils.touch(File.join(@tmp_dir,'README'))
    
    g.add('.')
    g.commit('first commit')
  end

  def add_hook
    in_current_dir do
      bin_file = File.join(File.expand_path('../../',File.dirname(__FILE__)), 'bin/syntaxer')
      hook_file = File.expand_path(File.join('.git/hooks/pre-commit'))
      File.open(hook_file, 'w') do |f|
        f.puts "#{bin_file} -c #{syntaxer_rules_example_file('syntaxer_rules_git')} -r git -p #{File.expand_path(@tmp_dir)}"
      end
      File.chmod(0755, hook_file)
    end
  end

  def make_git_commit
    g = Git.open File.expand_path(@tmp_dir) 
    g.add
    
    Dir.chdir(current_dir)
    g.commit('second commit')    
  end

end

World(PlainHelpers)
