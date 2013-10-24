module Vocalware
  # Basic Vocalware error.
  class Error < StandardError
  end

  # Raised when no voices or more than one are found.
  class FindVoiceError < Error
  end

  # Raised on sending and processing HTTP request to Vocalware service.
  class RequestError < Error
    # @attribute url [String] URL where request was sent
    attr_accessor :url

    # @attribute response [Faraday::Response] recevied response
    attr_accessor :response

    # Create instance with request URL and error message.
    #
    # @return [Vocalware::RequestError]
    def self.from_url(url, message)
      message << "\nREQUEST URL: #{url}"
      new(message)
    end

    # Create instance with request URL, response and error message.
    #
    # @return [Vocalware::RequestError]
    def self.from_url_and_response(url, response, message)
      message << "\nREQUEST URL: #{url}"
      message << "\nRESPONSE STATUS: #{response.status}"
      message << "\nRESPONSE BODY: #{response.body}"
      new(message)
    end
  end

  # Raised when required parameters for request are missing.
  class BuildRequestError < RequestError
  end
end
