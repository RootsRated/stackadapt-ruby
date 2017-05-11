module StackAdapt
  class Client
    module NativeAds
      All    = StackAdapt::Client::Route.new('native_ads', :get, true, StackAdapt::NativeAd)
      Create = StackAdapt::Client::Route.new('native_ad', :post, false, StackAdapt::NativeAd)
      Read   = StackAdapt::Client::Route.new('native_ad/:id', :get, false, StackAdapt::NativeAd)
      Update = StackAdapt::Client::Route.new('native_ad/:id', :put, false, StackAdapt::NativeAd)
      Delete = StackAdapt::Client::Route.new('native_ad/:id', :delete, false, StackAdapt::NativeAd)
    end
  end
end
