module StackAdapt
  module VERSION
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    PRE = nil

    def self.to_s
      [MAJOR, MINOR, PATCH, PRE].compact.join('.')
    end
  end

  def self.version
    VERSION.to_s
  end
end
