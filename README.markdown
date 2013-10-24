# Vocalware

Ruby client for the [Vocalware](https://www.vocalware.com/) REST API.

## Install

Add vocalware to your Gemfile:

```ruby
gem 'vocalware'
```

Run `bundle install`.

## Usage

Lookup a voice by its attributes:

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

Generate speech from text:

```ruby
audio_data = client.gen('Say hello on a night like this!')
File.binwrite('./cure.mp3', audio_data)
```

### Override attributes for a single request

If you need to say few words in Spanish, you can override the `:voice`
attribute for one single request:

```
voice = Vocalware::Vocalware.find(:lang => :es, :name => 'Juan')
client.gen('Hola! Qué tal estás?', :voice => voice)
```

## Running tests

```sh
rake spec
```


## Credits

* [Sergey Potapov](https://github.com/greyblake)

## Copyright

Copyright (c) 2013 TMX Credit. See LICENSE.txt for further details.
