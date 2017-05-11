module StackAdapt
  module Model
    autoload :Definitions, 'stackadapt/model/definitions'
    autoload :Routing, 'stackadapt/model/routing'

    class Base
      include Definitions
      include Routing

      extend Definitions::ClassMethods
      extend Routing::ClassMethods
    end
  end
end
