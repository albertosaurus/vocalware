# Vocalware

Ruby client for [Vocalware](https://www.vocalware.com/) REST API.

## Install

Add to Gemfile:

```ruby
gem 'vocalware'
```

Run `bundle install`.

## Usage

Lookup voice by attributes:
```ruby
voice = Vocalware::Voice.find(:lang => :en, :name => 'Kate')
```
As attributes you can also use `engine_id`, `lang_id`, `voice_id`, `gender`.

Initialize a client:
```ruby
client = Vocalware::Client.new(
  :secret_phrase => SECRET_PHRASE,
  :api_id        => API_ID,
  :account_id    => ACCOUNT_ID,
  :voice         => voice
  )
```

Generate speech:

```ruby
audio_data = client.gen('Say hello on the night like this!')
File.binwrite('./cure.mp3', audio_data)
```



## Copyright

Copyright (c) 2013 TMX Credit. Author Potapov Sergey. See LICENSE.txt for
further details.

