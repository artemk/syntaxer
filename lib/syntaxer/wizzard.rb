module Syntaxer
  class Wizzard
    # Interactive console wizzard
    LANG = [:ruby, :haml, :sass, :javascript]
    FOLDERS_RAILS = {
      :ruby => ["app/*", "app/**/*", "lib/*", "lib/**/*"],
      :haml => ["app/views/*", "app/views/**/*"],
      :sass => ["public/stylesheets/sass/*", "public/stylesheets/sass/**/*"],
      :javascript => ["public/javascript/*", "public/javascript/**/*"]
    }
    DEFAULT_GLOB = ["*/*", "**/*"]
    FOLDERS = {
      :ruby => DEFAULT_GLOB,
      :haml => DEFAULT_GLOB,
      :sass => DEFAULT_GLOB,
      :javascript => DEFAULT_GLOB
    }
    
    attr_accessor :options

    def initialize options
      @options = options
    end

    def run
      FileUtils.mkdir_p(@options[:config_path]) if !@options[:config_dir_exists] && @options[:create_config_dir]
      config_full_path = File.join(@options[:config_path], Syntaxer::SYNTAXER_CONFIG_FILE_NAME)
      File.open(config_full_path, 'w') do |f|
        f.write(config)
      end

      if @options[:git]
        options = {:root_path => @options[:root_path], :repository => :git, :config => config_full_path}
        options.merge!({:rails => true}) if options[:rails]
        Syntaxer.make_hook(options)
      end

      if @options[:rails] && @options[:languages].include?(:javascript)
        system('rake jslint:copy_config')
      end
    end

    def config
      reader = Reader::DSLReader.build
      writer = Writer.new(@options[:languages], reader.rules)
      writer.get_config
    end
    
    class << self
      
      def start
        options = {}
        options[:root_path] = Dir.getwd
        rails = false
        say("Some greeting message. Hello God of this computer! Please answer in couple of question:".color(:green))
        
        # ask for the languages to install
        to_install = []
        LANG.each do |lang|
          if agree("Install support of #{lang.to_s.capitalize}? (y/n)".color(:yellow))
            default_paths = rails? ? FOLDERS_RAILS[lang] : FOLDERS[lang]
            paths = ask("Paths to check separated by comma (default are #{default_paths.inspect}):".color(:yellow))
            if paths.empty?
              paths = default_paths
            else
              paths = paths.split(',').map{|l| l.gsub(/\s/,'')}
            end
            to_install.push([lang, paths])
          end
        end

        options[:languages] = to_install

        # ask for path to save config
        if rails?
          say("Rails application detected. Config file saved to config/synaxer.rb".color(:green))
          rails = true
          config_path = "config"
        else
          config_path = ask("Specify where to save syntaxer's config file (./ by default):".color(:yellow))
          config_path = '.' if config_path.empty?
          config_path = File.expand_path('.')
          options[:config_dir_exists] = FileTest.directory?(options[:config_path])
          options[:create_config_dir] = agree("No such directory found #{config_path}. Create it?".color(:green)) unless options[:config_dir_not_exists]
        end

        options[:rails] = rails
        options[:config_path] = config_path

        # trying to detect GIT
        begin
          g = ::Git.open(options[:root_path])
          options[:git] =  agree("Found git repo in #{File.expand_path(options[:root_path])}. Would you like install hook to check syntax before every commit? (y/n)".color(:yellow))
        rescue
          options[:git] = false
        end

       
        Wizzard.new(options).run
        
        # buy message
        say("Syntaxer is configured and installed. You can edit config in #{File.join(config_path, Syntaxer::SYNTAXER_CONFIG_FILE_NAME)}".color(:green))

      rescue Interrupt => e
        # external quit
        puts "\nBuy"
      end

      private
      
      def rails?
        FileTest.directory?("config") && FileTest.file?("config/application.rb") && FileTest.file?("config/routes.rb")
      end

    end
  end
end
