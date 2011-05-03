module Syntaxer
  class Wizzard
    # Interactive console wizzard
    LANG = [:ruby, :haml, :sass, :javascript]
    
    class << self
      
      def start
        @rails = false
        say("Some greeting message. Hello God of this computer! Please answer in couple of question:".color(:green))
        
        # ask for the languages to install
        to_install = []
        LANG.each do |lang|
          if agree("Install support of #{lang.to_s.capitalize}?")
            paths = ask("Paths to check separated by comma ([*/*, **/*] by default):")
            if paths.empty?
              paths = ['*/*','**/*']
            else
              paths = paths.split(',').map{|l| l.gsub(/\s/,'')}
            end
            to_install.push([lang, paths])
          end
        end
        reader = Reader::DSLReader.build
        writer = Writer.new(to_install, reader.rules)
        config = writer.get_config

        # ask for path to save config
        if FileTest.directory?("config") && FileTest.file?("config/application.rb")
          say("Rails application detected. Config file saved to config/synaxer.rb")
          @rails = true
          config_path = "config"
        else
          config_path = ask("Specify where to save syntaxer's config file (./ by default):")
          config_path = '.' if config_path.empty?
          config_path = File.expand_path('.')
          unless FileTest.directory?(config_path)
            if agree("No such directory found #{config_path}. Create it?")
              FileUtils.mkdir_p(config_path)
            end
          end
        end
        config_full_path = File.join(config_path, Syntaxer::SYNTAXER_CONFIG_FILE_NAME)
        File.open(config_full_path, 'w') do |f|
          f.write(config)
        end

        # trying to detect GIT
        begin
          g = ::Git.open(config_path)
          if agree("Found git repo in #{config_path}. Would you like install hook to check syntax before every commit?")
            options = {:root_path => config_path, :repository => :git}
            options.merge!({:rails => @rails}) if @rails
            Syntaxer.make_hook(options)
          end
        rescue
          
        end
        

        if @rails
          system('rake jslint:copy_config')
        end
        
        # buy message
        say("Syntaxer is configured and installed. You can edit config in #{config_full_path}".color(:green))

      rescue Interrupt => e
        # external quit
        puts "\nBuy"
      end
      
    end
    
  end
end
