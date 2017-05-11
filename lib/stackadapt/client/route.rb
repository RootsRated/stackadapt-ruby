module StackAdapt
  class Client
    Route = Struct.new(:endpoint, :method, :collection, :model_klass, :response_key) do
      def query(client, args, payload = {})
        Utils::QueryBuilder.new(self, client, args, payload)
      end

      def collection?
        !!collection
      end
    end
  end
end
