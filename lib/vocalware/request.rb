module Vocalware
  # Request to send to Vocalware's remote service.
  # Builds a URL with all necessary parameters according to the API.
  class Request
    # Required parameters according to the Vocalware API reference.
    REQUIRED_PARAMETERS = ['EID', 'LID', 'VID', 'TXT', 'ACC', 'API', 'CS']

    # @param attrs [Hash<Symbol, Object>]
    def initialize(attrs)
      @attrs = attrs
      validate!
    end

    # Build a query as a URL with GET parameters.
    #
    # @return [String]
    def to_url
      url = "#{@attrs[:protocol]}://#{@attrs[:host]}"
      url << ":#{@attrs[:port]}" if @attrs[:port]
      url << "#{@attrs[:path]}?"

      params_str = params.map {|name, value| "#{CGI.escape(name)}=#{CGI.escape(value)}" }.join('&')
      url << params_str
    end

    # Validate all required parameters are present.
    #
    # @return [void]
    def validate!
      REQUIRED_PARAMETERS.each do |name|
        if params[name].empty?
          raise(BuildRequestError, "Vocalware: Parameter #{name} is required")
        end
      end
    end
    private :validate!

    # Build GET parameters.
    #
    # @return [Hash<String, String>]
    def params
      @params ||= begin
        { 'EID'      => @attrs[:voice].engine_id.to_s,
          'LID'      => @attrs[:voice].lang_id.to_s,
          'VID'      => @attrs[:voice].voice_id.to_s,
          'TXT'      => @attrs[:text].to_s,
          'EXT'      => @attrs[:ext].to_s,
          'FX_TYPE'  => @attrs[:fx_type].to_s,
          'FX_LEVEL' => @attrs[:fx_level].to_s,
          'ACC'      => @attrs[:account_id].to_s,
          'API'      => @attrs[:api_id].to_s,
          'SESSION'  => @attrs[:session].to_s,
          'CS'       => checksum }
      end
    end
    private :params

    # Calculate checksum. The following formula is used:
    #   CS = md5(EID + LID + VID + TXT + EXT + FX_TYPE + FX_LEVEL +
    #            + fACC + API + SESSION + SECRET PHRASE)
    #
    # @return [String] MD5 hex digest
    def checksum
      @checksum ||= begin
        data = [
          @attrs[:voice].engine_id.to_s,
          @attrs[:voice].lang_id.to_s,
          @attrs[:voice].voice_id.to_s,
          @attrs[:text].to_s,
          @attrs[:ext].to_s,
          @attrs[:fx_type].to_s,
          @attrs[:fx_level].to_s,
          @attrs[:account_id].to_s,
          @attrs[:api_id].to_s,
          @attrs[:session].to_s,
          @attrs[:secret_phrase].to_s
        ].join('')
        Digest::MD5.hexdigest(data)
      end
    end
    private :checksum
  end
end
