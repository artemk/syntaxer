module Syntaxer

  # Contain filename, status of the syntax and list of errors

  class FileStatus
    @@error_files = []
    @@fine_files = []
    
    attr_reader :file_name, :status, :errors
    
    def initialize(file_name, errors = [])
      @errors = errors
      @file_name = file_name      
      @status = @errors.empty? ? :ok : :failed 
    end
    
    class << self
      def build(file_name, errors = [])
        file_status = new(file_name, errors)
        errors.empty? ? @@fine_files << file_status : @@error_files << file_status
      end   
      
      def error_files
         @@error_files
      end

      def fine_files
        @@fine_files
      end
         
    end
 
  end
end
