Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'ZomxM2Rq0LHdSKfRNzCvw', 'bU9R2XEroFI2ATlfM9uK211KXdl5HjIE67tfHup3wo'
  provider :facebook, '530378193668947','82c9e1056afb5fc6e71944dfc78db682', {:scope => 'publish_stream,offline_access,email', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}
end

Twitter.configure do |config|
  config.consumer_key = 'ZomxM2Rq0LHdSKfRNzCvw'
  config.consumer_secret = 'bU9R2XEroFI2ATlfM9uK211KXdl5HjIE67tfHup3wo'
  config.oauth_token = '456422016-fDrwaRPAfygld71gm2tQaVgVdgR4TGZ8HouNh5i0'
  config.oauth_token_secret = 'JUY6rxBKisEbwGdeuoaVimG6NleWj2lY0b8OmilQ'
end



