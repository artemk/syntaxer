module Syntaxer
  class Writer
    # Recreate config DSL string operation general rules and set of
    # languages
    
    EXCLUDE_PROPERTIES = "executor", "exec_existence", "deferred", "name"

    # Initializing Writer
    #
    # @param [Array] array of languages to recreate
    # @param [LanguageRules]
    def initialize langs, rules
      raise ArgumentError unless rules.kind_of?(LanguageRules)
      @config = ''
      @allowed_methods = ["syntaxer", "lang", "languages"]

      @config = syntaxer do
        lang_st = ''
        langs.each do |l|
          language = l.first
          @paths = l.last
          rule = rules.find(language)
          next if rule.nil?
          
          @allowed_methods += rule.members if (rule.members - @allowed_methods).length > 0
          lang_st += languages(rule.send(:name)) do
            prop_st = ''
            rule.members.each do |m|
              properties = rule.send(m)
              prop_st += property(m, properties) if m != "name"
            end
            prop_st
          end
        end
        lang_st
      end

    end

    # return config
    #
    # @return [String] DSL config string
    def get_config
      @config
    end

    protected
    def method_missing name, *args, &b
      name = name.to_sym
      super unless @allowed_methods.include?(name.to_s)
      if name == :lang || name == :syntaxer || name == :languages
        block(name, args.first, &b)
      else
        property(name, args)
      end
    end

    # Create DSL block
    #
    # @param [Symbol, String] block name
    # @param [String] parameter that is passed in to block
    # @return [String] DSL block string
    def block name, param = nil, &b
      sp = ' '*2 if name == :lang || name == :languages
      body = yield self if block_given?
      param = ":#{param.to_s}" unless param.nil?
      "#{sp}#{name.to_s} #{param} do\n#{body}\n#{sp}end\n"
    end

    # Create DSL property of block
    #
    # @param [String] name of the property
    # @param [Syntaxer::Runner, Array] properties
    # @return [String] DSL property string
    def property name, prop
      return '' if EXCLUDE_PROPERTIES.include?(name.to_s) || prop.nil? || (prop.kind_of?(Array) && prop.empty?)
      
      prop = prop.flatten.map{|p| "'#{p}'"}.join(', ') if prop.respond_to?(:flatten) && name.to_sym != :folders
      prop = @paths.map{|f| "'#{f}'"}.join(',') if name.to_sym == :folders
      
      prop = "'#{prop.exec_rule}'" if prop.instance_of?(Syntaxer::Runner::ExecRule) && !prop.exec_rule.nil?
      prop = "Syntaxer::Runner.#{prop.language}" if prop.instance_of?(Syntaxer::Runner::ExecRule) && prop.exec_rule.nil?
      
      ' '*4 + "#{name.to_s} #{prop}\n"
    end

  end
end
