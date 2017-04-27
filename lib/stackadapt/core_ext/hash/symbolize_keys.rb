module StackAdapt
  module CoreExt
    class Hash
      module SymbolizeKeys
        def deep_symbolize_keys!
          {}.tap do |h|
            each { |k, v| h[k.to_sym] = symbolize_value(v) }
          end
        end

        private

        def symbolize_value(object)
          case object
          when ::Hash; object.deep_symbolize_keys!
          when ::Array; object.collect { |v| symbolize_value(v) }
          else; object
          end
        end
      end
    end
  end
end

Hash.include StackAdapt::CoreExt::Hash::SymbolizeKeys
