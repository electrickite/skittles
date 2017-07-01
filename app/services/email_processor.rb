class EmailProcessor
  GAME_SUBJECT_REGEX = /.*\[Game ([1-9]+)\].*/.freeze

  def initialize(email)
    @email = email
    @user = nil
    @game = nil
  end

  def process
    game_id = @email.subject.to_s.strip[GAME_SUBJECT_REGEX, 1]
    line = @email.body.to_s.strip.lines.first.chomp.split(' ')
    notation = line[0]

    @user = User.find_by email: @email.from[:email]
    @game = Game.find game_id.to_i
    move = @game.build_next_move notation

    if @user.can? :create, move
      unless move.save
        log_error "Could not create specified move for game #{@game.id}. Errors were: #{move.errors.values.join(', ')}"
        send_error "Could not create specified move. Errors were: #{move.errors.values.join(', ')}"
      end
    else
      log_error "User #{@user.id} is not authorized to create moves for #{@game.active_color} in game #{@game.id}"
      send_error "You are not authorized to create moves for #{@game.active_color} in game #{@game.id}"
    end
  rescue => e
    log_error "There was an error parsing the message: #{e.class} - #{e}"
    if e.is_a? ActiveRecord::RecordNotFound
      send_error "There was an error parsing your message."
    else
      send_error "Game #{game_id} was not found."
    end
  end

  private

  def log_error(message)
    Rails.logger.error "[EMAIL PROCESSOR ERROR] #{message}"
  end

  def send_error(message)
    MoveMailer.move_error(@user, @game, message).deliver_later if @user
  end
end
