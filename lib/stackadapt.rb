require 'stackadapt/core_ext/hash/reverse_merge'
require 'stackadapt/core_ext/hash/symbolize_keys'

module StackAdapt
  autoload :Error, 'stackadapt/error'
  autoload :Model, 'stackadapt/model'

  autoload :Asset, 'stackadapt/models/asset'
  autoload :Campaign, 'stackadapt/models/campaign'
  autoload :ConversionTracker, 'stackadapt/models/conversion_tracker'
  autoload :NativeAd, 'stackadapt/models/native_ad'
end

require 'stackadapt/version'
require 'stackadapt/client'
