require 'csv'
require 'vocalware/client'
require 'vocalware/languages'
require 'vocalware/voice'


module Vocalware
  DATA_PATH = File.expand_path('../../data', __FILE__)

  VOICES_CSV_FILE = File.join(DATA_PATH, 'voices.csv')


  # Basic vocalware error.
  class Error < StandardError
  end

  # Is raised when no voices are found or found more than one.
  class FindVoiceError < Error
  end

end


