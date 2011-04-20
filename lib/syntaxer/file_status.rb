module Syntaxer

  # Contain filename, status of the syntax and list of errors

  class FileStatus
    @@error_files = []
    @@all_files = []
    
    attr_reader :file_name, :status, :errors
    
    def initialize(file_name, errors = [])
      @errors = errors
      @file_name = file_name      
      @status = @errors.empty? ? :ok : :failed 
    end
    
    class << self
      def build(file_name, errors = [])
        file_status = new(file_name, errors)
        @@all_files << file_status
        @@error_files << file_status unless errors.empty?
      end   
      
      def error_files
        @@error_files
      end

      def all_files
        @@all_files
      end
         
    end
 
  end
end
