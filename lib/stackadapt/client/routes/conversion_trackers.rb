module StackAdapt
  class Client
    module ConversionTrackers
      All    = StackAdapt::Client::Route.new('conversion_trackers', :get, true, StackAdapt::ConversionTracker)
      Create = StackAdapt::Client::Route.new('conversion_tracker', :post, false, StackAdapt::ConversionTracker)
      Read   = StackAdapt::Client::Route.new('conversion_tracker/:id', :get, false, StackAdapt::ConversionTracker)
      Update = StackAdapt::Client::Route.new('conversion_tracker/:id', :put, false, StackAdapt::ConversionTracker)
      Delete = StackAdapt::Client::Route.new('conversion_tracker/:id', :delete, false, StackAdapt::ConversionTracker)
    end
  end
end
