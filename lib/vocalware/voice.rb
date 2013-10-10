module Vocalware
  # Voice encapsulates voice parameters like +engine_id+, +voice_id+, +lang_id+
  # etc. And provides class method to look up voice by parameters.
  #
  # @example
  #   # Find a voice with name Juan. Exception will be raise if the voice with
  #   # such name is not unique. As well as if the voice not found.
  #   voice = Voice.find(:name => 'Juan')
  class Voice
    # @attr_reader engine_id [Integer, String] engine id which is used to generate speech
    attr_reader :engine_id

    # @attr_reader lang [Symbol, String] language ISO 639-1 code (2 chars)
    attr_reader :lang

    # @attr_reader name [String] voice name
    attr_reader :name

    # @attr_reader voice_id [Integer, String] unique only in scope of +engine_id+ and +lang+
    attr_reader :voice_id

    # @attr_reader gender [String] whether "M" or "F"
    attr_reader :gender

    # @attr_reader description [String] regions, dialects, etc
    attr_reader :description

    # @attr_reader lang_id [Integer, String] language id
    attr_reader :lang_id

    # Get all voices.
    #
    # @return [Array<Vocalware::Voice>]
    def self.all
      @all ||= send(:load_all)
    end

    # Find a voice by attributes.
    #
    # @param attrs [Hash] attributes to find a voice
    #
    # @return
    def self.find(attrs)
      voices = all.select {|voice| voice.match?(attrs) }

      raise(FindVoiceError, "No voice found using #{attrs.inspect}")          if voices.empty?
      raise(FindVoiceError, "More than 1 voice found using #{attrs.inspect}") if voices.size > 1

      voices.first
    end

    # Load and instantiate voices from CSV file.
    #
    # @return [Array<Vocalware::Voice>]
    def self.load_all
      converter = lambda { |str| str ? str.strip! : nil }
      data = CSV.read(VOICES_CSV_FILE,
                      :headers           => true,
                      :skip_blanks       => true,
                      :converters        => converter,
                      :header_converters => converter)
      data.map { |row| Voice.new(row.to_hash) }
    end
    private_class_method :load_all


    # @param attributes [Hash] voice attributes
    def initialize(attributes)
      attributes.each do |attr, value|
        self.instance_variable_set("@#{attr}", value)
      end
      @lang_id = LANGUAGES[lang.to_sym] || raise(Error, "Unknown lang #{lang.inspect}")
    end

    # Verify does voice match passed attributes.
    #
    # @param attributes [Hash]
    #
    # @return [Boolean]
    def match?(attributes)
      attributes.each do |attr, val|
        return false if send(attr).to_s != val.to_s
      end
      true
    end
  end
end
