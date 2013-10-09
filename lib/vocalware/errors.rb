module Vocalware
  # Bavic Vocalware error.
  class Error < StandardError
  end

  # Is raised when no voices are found or found more than one.
  class FindVoiceError < Error
  end

  # Is raised on sending and processing HTTP request to Vocalware service.
  class RequestError < Error
    # @attribute url [String] URL where request was sent
    attr_accessor :url

    # @attribute response [Faraday::Response] recevied response
    attr_accessor :response

    # Create instance with request URL and error message.
    #
    # @return [Vocalware::RequestError]
    def self.from_url(url, message)
      new(message).tap { |err| err.url = url }
    end

    # Create instance with request URL, response and error message.
    #
    # @return [Vocalware::RequestError]
    def self.from_url_and_response(url, response, message)
      from_url(url, message).tap { |err| err.response = response }
    end

    # Error message with info about request URL and response.
    #
    # @return [String]
    def message
      msg = super
      msg << "\nREQUEST URL: #{url}" if url
      if response
        msg << "\nRESPONSE STATUS: #{response.status}"
        msg << "\nRESPONSE BODY: #{response.body}"
      end
      msg
    end
  end

  # Is raised when required parameters for request are missing.
  class BuildRequestError < RequestError
  end
end
