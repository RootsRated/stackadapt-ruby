module StackAdapt
  module Model
    module Definitions
      module ClassMethods
        protected

        # Define methods that retrieve the value from attributes
        #
        # @param attrs [Symbol, Array<Symbol>]
        def attr_reader(*attrs)
          attrs.each do |attr|
            define_attribute_reader_method(attr)
            define_predicate_method(attr)
          end
        end

        # Define methods that retrive and write values from a nested attribute
        #
        # @param attrs [Symbol, Array<Symbol>]
        def attr_accessor(*attrs)
          attr_reader(*attrs)

          attrs.each do |attr|
            define_attribute_writer_method(attr)
          end
        end

        # Define method that retrieve the value from a nested attribute
        #
        # @param attr [Symbol]
        # @param key_path [Array<Symbol>]
        def nested_attr_reader(attr, *key_path)
          define_attribute_reader_method(attr, nil, key_path)
          define_predicate_method(attr, *key_path)
        end

        # Define methods that retrive and write values from a nested attribute
        #
        # @param attr [Symbol]
        # @param key_path [Array<Symbol>]
        def nested_attr_accessor(attr, *key_path)
          nested_attr_reader(attr, *key_path)
          define_attribute_writer_method(attr, *key_path)
        end

        # Define methods that retrieve the value from attributes
        # and serves them in a DateTime object
        #
        # @param attrs [Array, Symbol]
        def date_attr_reader(*attrs)
          attrs.each do |attr|
            define_method(attr) do
              DateTime.parse attr_value_fetch_for([attr])
            end
            define_predicate_method(attr)
          end
        end

        # Define methods that write the DateTime values for attributes
        # as ISO-8601 strings
        #
        # @param attrs [Array, Symbol]
        def date_attr_accessor(*attrs)
          date_attr_reader(*attrs)

          attrs.each do |attr|
            define_method("#{attr}=") do |value|
              @attrs.update(attr => value.iso8601)
            end
          end
        end

        # Define object reader methods from attributes
        #
        # @param klass [Symbol]
        # @param key [Symbol]
        # @param key_path [Array<Symbol>]
        def object_attr_reader(klass, key, *key_path)
          define_attribute_reader_method(key, klass, key_path)
          define_predicate_method(key, *key_path)
        end

        # Define object reader & writer methods from attributes
        #
        # @param klass [Symbol]
        # @param key [Symbol]
        # @param key_path [Array<Symbol>]
        def object_attr_accessor(klass, key, *key_path)
          object_attr_reader(klass, key, *key_path)

          define_method("#{key}=") do |value|
            @attrs.deep_reverse_merge! keypath_hash_for(key_path << key, value.send(:attrs))
          end
        end

        # Define collection object reader methods from attributes
        #
        # @param klass [Symbol]
        # @param key [Symbol]
        # @param key_path [Array<Symbol>]
        def collection_object_attr_reader(klass, key, *key_path)
          define_collection_attribute_method(key, klass, key_path)
          define_predicate_method(key, *key_path)
        end

        # Define collection object reader & writer methods from attributes
        #
        # @param klass [Symbol]
        # @param key [Symbol]
        # @param key_path [Array<Symbol>]
        def collection_object_attr_accessor(klass, key, *key_path)
          collection_object_attr_reader(klass, key, *key_path)

          define_method("#{key}=") do |values|
            @attrs.deep_reverse_merge! keypath_hash_for(key_path << key, values.collect { |o| o.send(:attrs) })
          end
        end

        private

        # Dynamically define a method for reading an attribute
        #
        # @param key [Symbol]
        # @param klass [Symbol]
        def define_attribute_reader_method(key, klass = nil, *key_path)
          define_method(key) do
            attr_value = attr_value_fetch_for(key_path.flatten << key)
            klass.nil? ? attr_value : StackAdapt.const_get(klass).new(attr_value)
          end
        end

        # Dynamically define a method for writing an attribute
        #
        # @param key [Symbol]
        def define_attribute_writer_method(key, *key_path)
          define_method(:"#{key}=") do |value|
            @attrs.deep_reverse_merge! keypath_hash_for(key_path << key, value)
          end
        end

        # Dynamically define a method for a collection of attribute
        #
        # @param key [Symbol]
        # @param klass [Symbol]
        def define_collection_attribute_method(key, klass = nil, *key_path)
          define_method(key) do
            attr_value = [attr_value_fetch_for(key_path.flatten << key)].flatten
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

      attr_accessor :attrs

      def attr_falsey_or_empty?(*key_path)
        attr_value = attr_value_fetch_for(*key_path)
        !attr_value || attr_value.respond_to?(:empty?) && attr_value.empty?
      end

      def attr_value_fetch_for(parts)
        parts.reduce(@attrs) { |attr, key| attr[key] if attr }
      end

      def keypath_hash_for(keypath, descendent_value = nil)
        return descendent_value unless keypath.any?

        { keypath.shift => keypath_hash_for(keypath, descendent_value) }
      end
    end
  end
end
