require 'spec_helper'
describe Vocalware::Client do
  let(:voice)       { Vocalware::Voice.find(:name => "Kate") }
  let(:http_client) { double(:http_client) }

  let(:client) do
    client = described_class.new(
      :account_id    => 13,
      :api_id        => 2025,
      :secret_phrase => "Lucretia",
      :voice         => voice,
      :ext           => 'swf',
      :host          => 'vocal.com',
      :protocol      => 'https',
      :port          => 4040,
      :http_client   => http_client
    )
  end

  describe '.new' do
    it 'should initialize client attributes from hash' do
      client.account_id.should    == 13
      client.api_id.should        == 2025
      client.secret_phrase.should == 'Lucretia'
      client.voice.should         == voice
      client.ext.should           == 'swf'
      client.host.should          == 'vocal.com'
      client.protocol.should      == 'https'
      client.port.should          == 4040
      client.http_client.should   == http_client
    end

    it 'should default attributes' do
      client = described_class.new(
        :account_id    => 1,
        :api_id        => 1,
        :secret_phrase => 's',
        :voice         => voice
      )

      client.protocol.should == 'http'
      client.host.should     == 'www.vocalware.com'
      client.path.should     == '/tts/gen.php'
      client.ext.should      == 'mp3'
    end
  end


  describe '#to_hash' do
    it 'converts attributes into hash' do
      hash = client.send(:to_hash)

      hash[:account_id].should    == 13
      hash[:api_id].should        == 2025
      hash[:secret_phrase].should == 'Lucretia'
      hash[:voice].should         == voice
      hash[:ext].should           == 'swf'
      hash[:host].should          == 'vocal.com'
      hash[:protocol].should      == 'https'
      hash[:port].should          == 4040
    end
  end
end
