Griddler.configure do |config|
  config.processor_class = EmailProcessor
  config.email_class = Griddler::Email
  config.processor_method = :process
  config.reply_delimiter = '-- REPLY ABOVE THIS LINE --'
  config.email_service = ENV.key?('EMAIL_SERVICE') ? ENV['EMAIL_SERVICE'].to_sym : :mailgun
end
