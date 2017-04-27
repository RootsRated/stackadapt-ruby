module StackAdapt
  class Client
    module Utils
      autoload :Request, 'stackadapt/client/utils/request'
      autoload :QueryBuilder, 'stackadapt/client/utils/query_builder'

      def included(base)
        base.class_eval <<-EOS
          def #{name.gsub(/([a-z\d])([A-Z])/, '\1_\2').gsub(/^.*::/, '').downcase}(*args)
            #{self.name}.builder(self, args)
          end
        EOS
      end

      attr_accessor :endpoint, :method, :collection, :model_klass, :response_key

      def builder(client, args)
        QueryBuilder.new(self, client, args)
      end

      def collection?
        !!@collection
      end
    end
  end
end
