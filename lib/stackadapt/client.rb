module StackAdapt
  class Client
    autoload :Route, 'stackadapt/client/route'
    autoload :Utils, 'stackadapt/client/utils'

    autoload :Campaigns, 'stackadapt/client/routes/campaigns'
    autoload :ConversionTrackers, 'stackadapt/client/routes/conversion_trackers'
    autoload :NativeAds, 'stackadapt/client/routes/native_ads'

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
