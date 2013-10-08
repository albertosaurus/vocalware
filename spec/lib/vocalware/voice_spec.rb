require 'spec_helper'

describe Vocalware::Voice do
  describe '.new' do
    it 'should raise if language is unknown' do
      expect { described_class.new(:lang => 'toki_pona') }.
        to raise_error(Vocalware::Error, 'Unknown lang "toki_pona"')
    end
  end

  describe '.all' do
    it 'should provide 82 voices' do
      described_class.all.size.should == 82
    end
  end

  describe '.find' do
    it 'should find voice by attributes' do
      voice = described_class.find(:lang => :en, :name => 'Kate')

      voice.name.should        == 'Kate'
      voice.engine_id.should   == '3'
      voice.lang.should        == 'en'
      voice.voice_id.should    == '1'
      voice.gender.should      == 'F'
      voice.description.should == 'US'
      voice.lang_id.should     == 1
    end

    it 'should raise if no voice found' do
      expect { described_class.find(:lang => 'Toki Pona') }.
        to raise_error(Vocalware::FindVoiceError, 'No voice found using {:lang=>"Toki Pona"}')
    end

    it 'should raise error if more than 1 voice found' do
      expect { described_class.find(:lang => :en) }.
        to raise_error(Vocalware::FindVoiceError, 'More than 1 voice found using {:lang=>:en}')
    end
  end



  describe '#match?' do
    let(:voice) { described_class.new(:lang => 'en', :name => "Woodie", :engine_id => '3', :voice_id => '101') }

    it 'should return true if attributes match' do
      voice.match?(:name  => "Woodie").should be_true
      voice.match?(:lang => 'en', :name => "Woodie", :engine_id => 3).should be_true

      voice.match?(:lang => 'en', :name => "Mickey").should be_false
    end

    it 'should work with symbols' do
      voice.match?(:lang => :en).should be_true
    end

    it 'should work with numbers' do
      voice.match?(:voice_id => 101).should be_true
    end
  end
end
