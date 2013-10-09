module Vocalware
  class Client
    # @attribute account_id [Integer, String] account id (ACC)
    attr_accessor :account_id

    # @attribute api_id [Integer, String] API id (API)
    attr_accessor :api_id

    # @attribute secret_phrase [String] secret phrase
    attr_accessor :secret_phrase

    # @attribute voice [Vocalware::Voice] voice
    attr_accessor :voice

    # @attribute ext [String] whether "mp3" or "swf"
    attr_accessor :ext

    # @attribute host [String] host to which request will be set
    attr_accessor :host

    # @attribute path [String] path as part of URL to send request
    attr_accessor :path

    # @attribute protocol [String] whether "http" or "https"
    attr_accessor :protocol

    # @attributes port [Integer]
    attr_accessor :port

    # Default attributes
    DEFAULT_ATTRS = {
      :ext      => 'mp3',
      :host     => 'www.vocalware.com',
      :path     => '/tts/gen.php',
      :protocol => 'http',
      :port     => nil
    }

    def initialize(attrs = {})
      DEFAULT_ATTRS.merge(attrs).each do |attr_name, value|
        send("#{attr_name}=", value)
      end

      validate!

      @http_client = Faraday.new
    end

    def build_url(text, opts = {})
      attrs = to_hash.merge(opts)
      attrs[:text] = text
      Request.new(attrs).to_url
    end

    def read(text, opts = {})
      url = build_url(text, opts)
      send_request(url)
    end

    def send_request(url)
      response = @http_client.get(url)

      # If response has other status than success
      unless response.status.between?(200, 299)
        raise RequestError.from_url_and_response(url, response, "Unexpected response status")
      end

      # In case of error Vocalware still returns 200 status, but with error
      # message in response body, instead of audio data.
      case response.headers['Content-Type']
      when 'audio/mpeg', 'application/x-shockwave-flash'
        return response.body
      else
        raise(RequestError, response.body)
      end
    rescue SocketError => err
      raise RequestError.from_url(url, err.message)
    end

    def validate!
      raise(Error, 'secret_phrase is missing') unless secret_phrase
      raise(Error, 'api_id is missing')        unless api_id
      raise(Error, 'voice is missing')         unless voice
      raise(Error, 'voice must be a Vocalware::Voice') unless voice.is_a?(Voice)
    end
    private :validate!

    def to_hash
      { :host          => host,
        :path          => path,
        :protocol      => protocol,
        :port          => port,
        :account_id    => account_id,
        :api_id        => api_id,
        :secret_phrase => secret_phrase,
        :voice         => voice,
        :ext           => ext }
    end
    private :to_hash
  end
end
