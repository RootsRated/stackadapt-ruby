require 'stackadapt/client/utils'

module StackAdapt
  class Client
    attr_accessor :api_token, :api_version

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [StackAdapt::Client]
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    # @return [String]
    def user_agent
      @user_agent ||= "StackAdapt-ruby/#{StackAdapt.version}"
    end
  end
end
