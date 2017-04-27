$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "stackadapt"

require "simplecov"
SimpleCov.start do
  add_filter 'lib/stackadapt/core_ext'

  add_group 'Models', 'lib/stackadapt/models'
  add_group 'Client', 'lib/stackadapt/client'
end
