class EmailProcessor < MessageProcessor
  METHOD = 'email'.freeze
  GAME_SUBJECT_REGEX = /.*\[Game ([1-9]+)\].*/.freeze

  private

  def game_id
    @game_id ||= @message.subject.to_s.strip[GAME_SUBJECT_REGEX, 1]
  end

  def user_conditions
    { email: @message.from[:email] }
  end

  def notation
    line[1] || line[0]
  end

  def token
    line[1] ? line[0] : ''
  end

  def send_errors
    GameMailer.move_error(user, game, errors).deliver_later if user
  end

  def line
    @line ||= @message.body.to_s.strip.lines.first.chomp.split(' ')
  end
end
