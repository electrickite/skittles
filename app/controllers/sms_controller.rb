class SmsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    response = Twilio::TwiML::VoiceResponse.new
    message = SmsProcessor.new(params)
    message.process

    if message.errors.any?
      response.sms message.errors.join(', ')
    end

    render xml: response.to_s
  end
end
