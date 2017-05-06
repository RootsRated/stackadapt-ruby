module StackAdapt
  module Model
    autoload :Definitions, 'stackadapt/model/definitions'

    class Base
      include Definitions
      extend Definitions::ClassMethods
    end
  end
end
