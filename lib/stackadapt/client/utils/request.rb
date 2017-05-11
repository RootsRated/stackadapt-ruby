require 'addressable/uri'
require 'http'
require 'http/form_data'
require 'json'

module StackAdapt
  class Client
    module Utils
      class Request
        autoload :Headers, 'stackadapt/client/utils/request/headers'

        BASE_URL = 'https://api.stackadapt.com/service'

        attr_accessor :client, :options, :path, :request_method
        alias_method :verb, :request_method

        def initialize(client, request_method, path, options = {})
          @client, @request_method, @path, @options = client, request_method, path, options
        end

        def perform
          response = HTTP.with(headers).public_send(request_method, uri.to_s, options_key => options)
          response.parse.deep_symbolize_keys!
        rescue HTTP::Error => e
          error(response.status, response.body.to_s, response.headers)
        rescue => e
          error(500, e.message, response.headers)
        end

        private

        def headers
          @_headers ||= Headers.new(self).request_headers
        end

        def options_key
          request_method == :get ? :params : :json
        end

        def uri
          @_uri ||= Addressable::URI.parse(path.start_with?('http') ? path : "#{BASE_URL}/v#{client.api_version}/#{path}")
        end

        def error(code, body, headers)
          if klass = StackAdapt::Error::HTTP_ERRORS[code]
            raise klass.new(code, body, headers)
          end
        end
      end
    end
  end
end
