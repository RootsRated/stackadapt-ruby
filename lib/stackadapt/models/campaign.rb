module StackAdapt
  class Campaign < Model::Base
    attr_reader :id, :name, :state, :bid_type, :budget, :daily_cap, :pace_evenly, :category_options, :country_options, :device_os_family_options, :device_os_options, :supply_type_options, :bid_amount_total, :supply_source_options, :us_state_options, :us_state_options, :device_type_options, :freq_cap_time, :freq_cap_limit, :city_options, :language_options, :ip_options, :allow_iframe_engagement, :use_dma, :engagement_tracking_type, :insertion_order_id, :advertiser_id
    date_attr_reader :start_date, :end_date, :created_at, :updated_at

    collection_object_attr_reader :ConversionTracker, :conversion_trackers
    collection_object_attr_reader :NativeAd, :all_native_ads
  end
end
