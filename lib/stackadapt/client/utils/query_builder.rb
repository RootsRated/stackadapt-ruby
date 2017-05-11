require 'forwardable'

module StackAdapt
  class Client
    module Utils
      class QueryBuilder
        extend Forwardable

        attr_reader :subject, :client, :method, :endpoint, :args, :payload
        def_delegators :subject, :endpoint, :method, :collection?, :model_klass, :response_key

        def initialize(subject, client, args, payload)
          @subject, @client, @args, @payload = subject, client, args, payload
        end

        def results
          collection? ? response[:data].collect { |r| result_object_for(r) } : result_object_for(response)
        end

        private

        def request_opts
          @_request_opts ||= payload || {}
        end

        def append_query(opts_block, args)
          opts = args.count > 0 ? opts_block.call(args) : opts_block.call
          request_opts.merge opts
        end

        def response
          raise MissingParameters if endpoint_with_params.index(':')

          @_response ||= Request.new(client, method, endpoint_with_params, request_opts).perform
        end
        alias :query! :response

        def endpoint_with_params
          return endpoint unless endpoint.index(":")

          endpoint.gsub(/(:([\w|]+))/, Hash[params])
        end

        def endpoint_param_keys
          @_endpoint_param_keys ||= endpoint.split('/').select { |s| s[0] == ":" }
        end

        def params
          endpoint_param_keys.each_with_index.collect do |param_key, index|
            begin
              [param_key, args.fetch(index)]
            rescue IndexError => e
              raise MissingParameters, "Missing value for parameter #{param_key}(#{index})"
            end
          end
        end

        def method_missing(m, *args, &block)
          results.public_send(m, *args, &block) if results.respond_to?(m)
        end

        def self.method_missing(m, *args, &block)
          results.class.public_send(m, *args, &block) if results.class.respond_to?(m)
        end

        def result_object_for(result)
          klass = model_klass if model_klass.is_a?(Class)
          klass ||= StackAdapt.const_get(model_klass) if model_klass.is_a?(Symbol) || model_klass.is_a?(String)
          klass ||= model_klass.call(result) if model_klass.respond_to?(:call)
          klass.new(result).tap { |object| object.client = client }
        end

        class MissingParameters < StandardError; end
      end
    end
  end
end
