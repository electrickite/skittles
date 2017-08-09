# Initializer contains miscellaneous custom application configuration settings

Rails.application.config.x.engine_path = ENV['ENGINE_PATH'] || 'stockfish'

Rails.application.config.x.phone_number = ENV['PHONE_NUMBER']
Rails.application.config.x.twilio.account_sid = ENV['TWILIO_ACCOUNT_SID']
Rails.application.config.x.twilio.auth_token = ENV['TWILIO_AUTH_TOKEN']
