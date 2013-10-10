require 'spec_helper'
require 'faraday/adapter/test'

describe 'Generate speech' do
  let(:hello_req)        { '/tts/gen.php?ACC=13&API=2025&CS=fc89622c1dca2af7671fa814e3dd88e0&EID=3&EXT=mp3&FX_LEVEL=&FX_TYPE=&LID=1&SESSION=&TXT=Say+hello+on+a+day+like+today%21&VID=1' }
  let(:text_error_req)   { '/tts/gen.php?ACC=13&API=2025&CS=5e621fed6db33bf7bc2e3127eefd7da6&EID=3&EXT=mp3&FX_LEVEL=&FX_TYPE=&LID=1&SESSION=&TXT=Text+error&VID=1'   }
  let(:status_error_req) { '/tts/gen.php?ACC=13&API=2025&CS=e161e785d5d9ad922eee93f08ccd0577&EID=3&EXT=mp3&FX_LEVEL=&FX_TYPE=&LID=1&SESSION=&TXT=Status+error&VID=1' }

  let(:voice) { Vocalware::Voice.find(:lang => :en, :name => 'Kate') }

  let(:http_client) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get(hello_req)        {[200, {'Content-Type' => 'audio/mpeg'}, 'Audio data: hello' ]}
        stub.get(text_error_req)   {[200, {'Content-Type' => 'text/html' }, 'Error 101' ]}
        stub.get(status_error_req) {[500, {'Content-Type' => 'text/html' }, 'Server error' ]}
      end
    end
  end

  let(:client) do
    Vocalware::Client.new(
      :secret_phrase => 'Lucretia',
      :account_id    => 13,
      :api_id        => 2025,
      :voice         => voice,
      :http_client   => http_client
    )
  end

  it 'should send request and return audio data' do
    client.gen("Say hello on a day like today!").should == 'Audio data: hello'
  end

  it 'should raise RequestError if server returns Content-Type = text/html' do
    expect { client.gen("Text error") }.
      to raise_error(Vocalware::RequestError, 'Error 101')
  end

  it 'should raise RequestError if server returns non success status' do
    expect { client.gen("Status error") }.
      to raise_error(Vocalware::RequestError, /Unexpected response status/)
  end

  it 'should raise RequestError if SocketError occurs' do
    http_client.should_receive(:get).and_raise(SocketError.new('Wrong address'))
    expect { client.gen('Socket error') }.
      to raise_error(Vocalware::RequestError, /Wrong address/)
  end
end
