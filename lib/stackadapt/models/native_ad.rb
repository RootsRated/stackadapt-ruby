module StackAdapt
  class NativeAd < Model::Base
    attr_reader :id, :name, :click_url, :audit_status, :state, :imp_tracker_urls, :api_frameworks, :brandname
    nested_attr_reader :heading, :input_data
    nested_attr_reader :tagline, :input_data
    nested_attr_reader :vast_xml, :input_data
    nested_attr_reader :landing_url, :input_data
    date_attr_reader :created_at, :updated_at

    collection_object_attr_reader :Asset, :creatives
    object_attr_reader :Asset, :icon
  end
end
