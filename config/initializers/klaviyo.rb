require "klaviyo-api-sdk"

# Setup authorization
KlaviyoAPI.configure do |config|
  config.api_key["Klaviyo-API-Key"] = "Klaviyo-API-Key pk_a93830db956f2340d2e312e36ecfa0ebc0"
  # config.max_retries = 5 # optional
  # config.max_delay = 60 # optional
end
