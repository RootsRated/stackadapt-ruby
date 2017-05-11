require 'json'

module StackAdapt
  module Model
    module Routing
      module ClassMethods
        def connect_route_to(method, route, opts = {})
          opts.reverse_merge!(
            instance_args: [],
            on:            :instance,
          )

          define_route_for(method, route, opts)
        end

        private

        def define_route_for(method, route, opts)
          case opts.delete(:on)
          when :class
            define_route_class_method(method, route, opts)
          when :instance
            define_route_instance_method(method, route, opts)
          else
            raise "Routes may be connected to :class or :instance only"
          end
        end

        def define_route_class_method(method, route, opts)
          define_singleton_method(method) do |client_override = nil, args={}|
            route.query(client_override || self.client, args, {})
          end
        end

        def define_route_instance_method(method, route, opts)
          define_method(method) do |client_override = nil|
            argument_values = opts[:instance_args].collect { |key| public_send(key) }
            route.query(client_override || self.client, argument_values, attrs)
          end
        end
      end

      attr_accessor :client
    end
  end
end
