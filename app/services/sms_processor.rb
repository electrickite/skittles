class SmsProcessor < MessageProcessor
  METHOD = 'sms'.freeze

  private

  def game_id
    body[0]
  end

  def user_conditions
    { phone: @message['From'].sub('+', '') }
  end

  def notation
    body[2] || body[1]
  end

  def token
    body[2] ? body[1] : ''
  end

  def body
    @body ||= @message['Body'].squish.split(' ')
  end
end
