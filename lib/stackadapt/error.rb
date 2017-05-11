module StackAdapt
  class Error < StandardError
    # @return [Integer]
    attr_reader :code

    # Raised when StackAdapt returns a 4xx HTTP status code
    ClientError = Class.new(self)

      # Raised when StackAdapt returns the HTTP status code 400
      BadRequest = Class.new(ClientError)

      # Raised when StackAdapt returns the HTTP status code 401
      Unauthorized = Class.new(ClientError)

      # Raised when StackAdapt returns the HTTP status code 403
      Forbidden = Class.new(ClientError)

      # Raised when StackAdapt returns the HTTP status code 404
      NotFound = Class.new(ClientError)

      # Raised when StackAdapt returns the HTTP status code 406
      NotAcceptable = Class.new(ClientError)

      # Raised when StackAdapt returns the HTTP status code 410
      Gone = Class.new(ClientError)

      # Raised when StackAdapt returns the HTTP status code 422
      UnprocessableEntity = Class.new(ClientError)

      # Raised when StackAdapt returns the HTTP status code 429
      TooManyRequests = Class.new(ClientError)

    # Raised when StackAdapt returns a 5xx HTTP status code
    ServerError = Class.new(self)

      # Raised when StackAdapt returns the HTTP status code 500
      InternalServerError = Class.new(ServerError)

      # Raised when StackAdapt returns the HTTP status code 502
      BadGateway = Class.new(ServerError)

      # Raised when StackAdapt returns the HTTP status code 503
      ServiceUnavailable = Class.new(ServerError)

      # Raised when StackAdapt returns the HTTP status code 504
      GatewayTimeout = Class.new(ServerError)

    HTTP_ERRORS = {
      400 => StackAdapt::Error::BadRequest,
      401 => StackAdapt::Error::Unauthorized,
      403 => StackAdapt::Error::Forbidden,
      404 => StackAdapt::Error::NotFound,
      406 => StackAdapt::Error::NotAcceptable,
      410 => StackAdapt::Error::Gone,
      422 => StackAdapt::Error::UnprocessableEntity,
      429 => StackAdapt::Error::TooManyRequests,
      500 => StackAdapt::Error::InternalServerError,
      502 => StackAdapt::Error::BadGateway,
      503 => StackAdapt::Error::ServiceUnavailable,
      504 => StackAdapt::Error::GatewayTimeout,
    }

    attr_reader :code

    def initialize(code = nil, body = nil, headers = [])
      @code, @body, @headers = (code || HTTP_ERRORS.invert[self.class]), body, headers
    end

    def message
      self.class.name.gsub(/^.*::/, '').gsub(/(?!^)([A-Z])/, ' \1')
    end
  end
end
