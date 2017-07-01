require_relative 'boot'   

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Skittles
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_mailer.delivery_method = :smtp

    if ENV['SMTP_ADDRESS']
      config.action_mailer.smtp_settings = {
        port:           ENV['SMTP_PORT'] || 587,
        address:        ENV['SMTP_ADDRESS'],
        domain:         ENV['SMTP_DOMAIN'],
        user_name:      ENV['SMTP_USERNAME'],
        password:       ENV['SMTP_PASSWORD'],
        authentication: :plain,
      }
    end
  end
end
