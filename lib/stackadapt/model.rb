module StackAdapt
  module Model
    class Base
      class << self
        protected

        # Define methods that retrieve the value from attributes
        #
        # @param attrs [Symbol, Array<Symbol>]
        def attr_reader(*attrs)
          attrs.each do |attr|
            define_attribute_method(attr)
            define_predicate_method(attr)
          end
        end

        # Define method that retrieve the value from a nested attribute
        #
        # @param attr [Symbol]
        # @param key_path [Array<Symbol>]
        def nested_attr_reader(attr, *key_path)
          define_attribute_method(attr, nil, key_path)
          define_predicate_method(attr)
        end

        # Define methods that retrieve the value from attributes
        # and serves them in a DateTime object
        #
        # @param attrs [Array, Symbol]
        def date_attr_reader(*attrs)
          attrs.each do |attr|
            define_method(attr) do
              DateTime.parse nested_attr([attr])
            end
            define_predicate_method(attr)
          end
        end

        # Define object methods from attributes
        #
        # @param klass [Symbol]
        # @param key [Symbol]
        # @param key_path [Array<Symbol>]
        def object_attr_reader(klass, key, *key_path)
          define_attribute_method(key, klass, key_path)
          define_predicate_method(key, key_path)
        end

        # Define collection object methods from attributes
        #
        # @param klass [Symbol]
        # @param key [Symbol]
        # @param key_path [Array<Symbol>]
        def collection_object_attr_reader(klass, key, *key_path)
          define_collection_attribute_method(key, klass, key_path)
          define_predicate_method(key, key_path)
        end

        private

        # Dynamically define a method for an attribute
        #
        # @param key [Symbol]
        # @param klass [Symbol]
        def define_attribute_method(key, klass = nil, *key_path)
          define_method(key) do
            attr_value = nested_attr(key_path.flatten << key)
            klass.nil? ? attr_value : StackAdapt.const_get(klass).new(attr_value)
          end
        end

        # Dynamically define a method for a collection of attribute
        #
        # @param key [Symbol]
        # @param klass [Symbol]
        def define_collection_attribute_method(key, klass = nil, *key_path)
          define_method(key) do
            attr_value = [nested_attr(key_path.flatten << key)].flatten
            klass.nil? ? attr_value : attr_value.collect { |v| StackAdapt.const_get(klass).new(v) }
          end
        end

        # Dynamically define a predicate method for an attribute
        #
        # @param key [Symbol]
        def define_predicate_method(key, *key_path)
          define_method(:"#{key}?") { !attr_falsey_or_empty?(key_path << key) }
        end
      end

      def initialize(attrs = {})
        @attrs = attrs
      end

      private

      def attr_falsey_or_empty?(*key_path)
        attr_value = nested_attr(key_path)
        !attr_value || attr_value.respond_to?(:empty?) && attr_value.empty?
      end

      def nested_attr(parts)
        parts.reduce(@attrs) { |attr, key| attr[key] if attr }
      end
    end
  end
end
