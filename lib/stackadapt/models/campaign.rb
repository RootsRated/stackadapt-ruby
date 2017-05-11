module StackAdapt
  class Campaign < Model::Base
    attr_reader :id, :device_os_family_options, :device_os_options, :language_options, :ip_options, :engagement_tracking_type, :insertion_order_id, :advertiser_id
    attr_accessor :name, :budget, :bid_type, :bid_amount_total, :optimize_type, :optimize_value, :daily_cap, :pace_evenly, :state, :category_options, :country_options, :us_state_options, :canada_province_options, :city_options, :domain_action, :domain_options, :device_type_options, :supply_type_options, :supply_source_options, :freq_cap_limit, :freq_cap_time, :language_options, :use_dma, :allow_iframe_engagement
    date_attr_accessor :start_date, :end_date
    date_attr_reader :created_at, :updated_at

    object_attr_reader :Advertiser, :advertiser
    collection_object_attr_reader :ConversionTracker, :conversion_trackers
    collection_object_attr_reader :NativeAd, :all_native_ads

    connect_route_to :all, StackAdapt::Client::Campaigns::All, on: :class
    connect_route_to :save_and_create, StackAdapt::Client::Campaigns::Create, instance_args: [:id]
    connect_route_to :save_and_update, StackAdapt::Client::Campaigns::Update, instance_args: [:id]

    def save
      id? ? save_and_update : save_and_create
    end
  end
end
