require 'spec_helper'

describe Vocalware::RequestError do
  describe '.from_url' do
    it 'should create an instance with URL and error message' do
      err = described_class.from_url('http://vocalware.com/gen.php', 'Ooops')
      err.message.should ==
        "Ooops\n" \
        "REQUEST URL: http://vocalware.com/gen.php"
    end
  end

  describe '.from_url_and_response' do
    it 'should create an instance with URL, response and error message' do
      response =  Faraday::Response.new(:status => 502, :body => "Grrr!")
      err = described_class.from_url_and_response(
              'http://vocalware.com/gen.php',
              response,
              'Ooops'
            )
      err.message.should ==
        "Ooops\n" \
        "REQUEST URL: http://vocalware.com/gen.php\n" \
        "RESPONSE STATUS: 502\n" \
        "RESPONSE BODY: Grrr!"
    end
  end
end
