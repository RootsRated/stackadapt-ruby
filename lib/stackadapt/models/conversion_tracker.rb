module StackAdapt
  class ConversionTracker < Model::Base
    attr_reader :id
    attr_accessor :name, :code, :description, :user_id, :conv_type, :post_time, :count_type

    connect_route_to :all, StackAdapt::Client::ConversionTrackers::All, on: :class
    connect_route_to :save_and_create, StackAdapt::Client::ConversionTrackers::Create, instance_args: [:id]
    connect_route_to :save_and_update, StackAdapt::Client::ConversionTrackers::Update, instance_args: [:id]

    def save
      id? ? save_and_update : save_and_create
    end
  end
end
