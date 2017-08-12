class MessageProcessor
  attr_reader :game, :user, :errors

  def initialize(message)
    @message = message
    @errors = []
  end

  def process
    @user = User.find_by! user_conditions
    @game = Game.find game_id
    move = game.build_next_move notation

    user.authorize! :play_via, message_type
    user.authorize! :play_using_token, token
    user.authorize! :create, move

    unless move.save
      log_error "Could not create specified move for game #{game.id}. Errors were: #{move.errors.values.join(', ')}"
      add_error "Could not create specified move. Errors were: #{move.errors.values.join(', ')}"
    end

  rescue ActiveRecord::RecordNotFound
    if user
      log_error "Could not find game id: #{game_id}"
      add_error "Game not found."
    else
      log_error "Could not find user with #{user_conditions}"
      add_error "Your user account could not be located."
    end

  rescue CanCan::AccessDenied
    log_error "The user is not authorized to play becuase of message type, token, or ability."
    add_error "You are not allowed to play the game as requested."

  rescue => e
    log_error "There was an error parsing the message: #{e.class} - #{e}"
    add_error "There was an error parsing your message."

  ensure
    send_errors if errors.any?
  end

  private

  def game_id
    # Implement in subclass
  end

  def user_conditions
    # Implement in subclass
  end

  def notation
    # Implement in subclass
  end

  def token
    # Implement in subclass
  end

  def send_errors
    # Implement in subclass (optional)
  end

  def log_error(error_message)
    Rails.logger.error "[#{self.class.name.titleize.upcase} ERROR] #{error_message}"
  end

  def add_error(error_message)
    @errors << error_message
  end

  def message_type
    # Get message type from class name
    self.class.name.titleize.split(' ').first.downcase.to_sym
  end
end
