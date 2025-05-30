require "klaviyo-api-sdk"

# Setup authorization
KlaviyoAPI.configure do |config|
  config.api_key["Klaviyo-API-Key"] = "Klaviyo-API-Key COPY_AND_PASTE_API_KEY_HERE"
  # config.max_retries = 5 # optional
  # config.max_delay = 60 # optional
end