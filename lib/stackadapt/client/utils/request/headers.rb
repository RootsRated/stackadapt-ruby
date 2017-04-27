require 'base64'

module StackAdapt
  class Client
    module Utils
      class Request
        class Headers
          extend Forwardable

          attr_reader :request
          def_delegators :request, :client, :request_method, :uri, :options

          def initialize(request)
            @request = request
          end

          def request_headers
            {}.tap do |headers|
              headers[:user_agent]        = client.user_agent
              headers[:accept]            = "application/json"
              headers[:"x-authorization"] = client.api_token
            end
          end
        end
      end
    end
  end
end
