class NotificationService
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def new_game
    @message = "Game #{@game.id} was created by #{@game.owner}. #{@game.white_player} is playing white and #{@game.black_player} is playing black."
    @subject = 'New game'

    game.watchers.each do |user|
      send_to(user) unless user == @game.owner
    end
  end

  def new_move
    @subject = 'New move'
    move = game.current_move

    @message = "#{move.player} made a move in game #{game.id}: #{move.color} #{move.notation}"
    if move.checkmate?
      @message << " \nCheckmate!" if move.checkmate?
    elsif move.check?
      @message << " \nCheck!" if move.check?
    end

    game.watchers.each do |user|
      send_to(user) unless user == move.user
    end
  end

  def game_over
    @subject = 'Game over'
    winner = @game.winner

    @message = if winner
      "#{winner} playing as #{winner.color} won game #{@game.id}."
    else
      "Game #{@game.id} ended with a #{@game.status.humanize}."
    end

    game.watchers.each do |user|
      send_to user
    end
  end

  private

  def send_to(user)
    GameMailer.notification(user, @game, @subject, @message).deliver_later if user.notify_email?
    SmsNotificationJob.perform_later(user, sms_message) if user.notify_sms?
  end

  def sms_message
    "#{@message}\n#{@game.to_pos}"
  end
end
