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
  end
end
