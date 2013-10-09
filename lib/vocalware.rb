# Standard library
require 'csv'
require 'digest'
require 'cgi'

# Gems
require 'faraday'

# Vocalware
require 'vocalware/errors'
require 'vocalware/client'
require 'vocalware/languages'
require 'vocalware/voice'
require 'vocalware/request'


module Vocalware
  DATA_PATH = File.expand_path('../../data', __FILE__)

  VOICES_CSV_FILE = File.join(DATA_PATH, 'voices.csv')
end


