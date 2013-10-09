require 'csv'
require 'digest'

require 'uri'
require 'cgi'

require 'vocalware/client'
require 'vocalware/languages'
require 'vocalware/voice'
require 'vocalware/request'


module Vocalware
  DATA_PATH = File.expand_path('../../data', __FILE__)

  VOICES_CSV_FILE = File.join(DATA_PATH, 'voices.csv')


  # Basic vocalware error.
  class Error < StandardError
  end

  # Is raised when no voices are found or found more than one.
  class FindVoiceError < Error
  end

  class RequestError < Error
  end
end


