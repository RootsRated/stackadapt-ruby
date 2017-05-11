module StackAdapt
  class Client
    module Campaigns
      All    = StackAdapt::Client::Route.new('campaigns', :get, true, StackAdapt::Campaign)
      Create = StackAdapt::Client::Route.new('campaign', :post, false, StackAdapt::Campaign)
      Read   = StackAdapt::Client::Route.new('campaign/:id', :get, false, StackAdapt::Campaign)
      Update = StackAdapt::Client::Route.new('campaign/:id', :put, false, StackAdapt::Campaign)
      Delete = StackAdapt::Client::Route.new('campaign/:id', :delete, false, StackAdapt::Campaign)
    end
  end
end
