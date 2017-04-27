module StackAdapt
  class ConversionTracker < Model::Base
    attr_reader :id, :name, :description, :user_id, :conv_type, :post_time, :count_type
  end
end
