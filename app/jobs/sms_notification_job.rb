class SmsNotificationJob < ApplicationJob
  queue_as :default
 
  def perform(user, message)
    client = Twilio::REST::Client.new Rails.configuration.x.twilio.account_sid, Rails.configuration.x.twilio.auth_token

    client.messages.create(
      from: Rails.configuration.x.phone_number,
      to: user.phone,
      body: message
    )
  end
end
