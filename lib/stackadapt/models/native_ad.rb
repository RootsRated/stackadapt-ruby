module StackAdapt
  class NativeAd < Model::Base
    attr_reader :id, :audit_status
    attr_accessor :name, :click_url, :state, :imp_tracker_urls, :api_frameworks, :brandname
    nested_attr_accessor :heading, :input_data
    nested_attr_accessor :tagline, :input_data
    nested_attr_accessor :vast_xml, :input_data
    nested_attr_accessor :landing_url, :input_data
    date_attr_reader :created_at, :updated_at

    collection_object_attr_reader :Asset, :creatives_attributes
    object_attr_reader :Asset, :icon

    connect_route_to :all, StackAdapt::Client::NativeAds::All, on: :class
    connect_route_to :save_and_create, StackAdapt::Client::NativeAds::Create, instance_args: [:id]
    connect_route_to :save_and_update, StackAdapt::Client::NativeAds::Update, instance_args: [:id]

    def save
      id? ? save_and_update : save_and_create
    end
  end
end
