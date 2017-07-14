class MessageProcessor
  attr_reader :game, :user, :errors

  def initialize(message)
    @message = message
    @errors = []
  end

  def process
    @user = User.find_by user_conditions
    @game = Game.find game_id
    move = game.build_next_move notation

    if user.blank?
      log_error "Could not find user with #{user_conditions}"
      add_error "Your user account could be located."
    elsif user.cannot? :create, move
      log_error "User #{user.id} is not authorized to create moves for #{game.active_color} in game #{game.id}"
      add_error "You are not authorized to create moves for #{game.active_color} in game #{game.id}"
    else
      unless move.save
        log_error "Could not create specified move for game #{game.id}. Errors were: #{move.errors.values.join(', ')}"
        add_error "Could not create specified move. Errors were: #{move.errors.values.join(', ')}"
      end
    end

  rescue => e
    log_error "There was an error parsing the message: #{e.class} - #{e}"

    if e.is_a? ActiveRecord::RecordNotFound
      add_error "Game not found."
    else
      add_error "There was an error parsing your message."
    end

  ensure
    send_errors if errors.any?
  end

  private

  def game_id
  end

  def user_conditions
  end

  def notation
  end

  def log_error(error_message)
    Rails.logger.error "[#{self.class.name.titleize.upcase} ERROR] #{error_message}"
  end

  def add_error(error_message)
    @errors << error_message
  end

  def send_errors
  end

  def is_number?(value)
    value.to_s == value.to_i.to_s
  end
end
