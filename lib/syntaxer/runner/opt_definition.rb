module Syntaxer
  module Runner
    module OptDefinition

      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods

        def flag_opt name, default = false
          define_method("#{name}=") do |value|
            raise ArgumentError, "Not valid value. Should be true of false" unless value.kind_of?(FalseClass) || value.kind_of?(TrueClass)
            instance_variable_set("@#{name}", value)
          end
          define_method("#{name}?") do
            instance_variable_set("@#{name}", default) if instance_variable_get("@#{name}").nil?
            instance_variable_get("@#{name}")
          end
        end

        def data_opt name, default = nil, &block
          define_method("#{name}=") do |value|
            raise ArgumentError, "Not valid value" if block_given? && !block.call(value)
            instance_variable_set("@#{name}", value)
          end
          define_method("#{name}") do
            instance_variable_set("@#{name}", default) if instance_variable_get("@#{name}").nil?
            instance_variable_get("@#{name}")
          end
          define_method("#{name}?") do
            !instance_variable_get("@#{name}").nil?
          end
        end

        def action_opt name, default = false
          define_method("#{name}=") do |value|
            raise ArgumentError, "Not valid value. Should be true of false" unless value.kind_of?(FalseClass) || value.kind_of?(TrueClass)
            instance_variable_set("@run_#{name}", value)
            instance_variable_set("@default_action", name) if default
          end
          define_method("run_#{name}?") do
            instance_variable_set("@run_#{name}", default) if instance_variable_get("@run_#{name}").nil?
            instance_variable_get("@run_#{name}")
          end
        end
      end
      
    end
  end
end
