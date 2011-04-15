module Syntaxer
  class RepositoryError < Exception; end
  class GitRepositoryError < RepositoryError; end
  class SvnRepositoryError < RepositoryError; end
  
  class Repository
    
    def self.factory(root_path, type_of_repository)
      case type_of_repository.to_sym
      when :git then Git.new(root_path)
      when :svn then Svn.new(root_path)
      end
    end
    
  end

  
  class Git
    require "git"
        
    def initialize(repo_path)
      @repository = ::Git.open(Dir.new(repo_path))
    rescue ArgumentError => ex
        raise GitRepositoryError, "The path you specified is not a git repository: '#{File.expand_path(repo_path)}'"
    end

    # Returns list of files what have been changed
    #
    # @return [Array]

    def changed_files
      @repository.chdir do
        @changed ||= @repository.status.changed.keys
      end
    end

    # Returns list of files what have been added
    #
    # @return [Array]
    
    def added_files
      @repository.chdir do
        @added ||= @repository.status.added.keys
      end
    end

    # Aggregates added and changed files in one array
    #
    # @return [Array]
    
    def changed_and_added_files
      changed_files + added_files
    rescue
      []
    end
=begin
    private
    def check_repo repository
      @logs = @repository.log
      @logs.first
    rescue ::Git::GitExecuteError => e
      puts "\nRepository is empty. There are no any revision.".color(:red)
      raise e
      exit 1
    end
=end
  end
  
  
  class Svn
    def initialize
      raise "TDB"    
    end
    
    def changed_files_list
      raise "TDB"      
    end
  end

end
