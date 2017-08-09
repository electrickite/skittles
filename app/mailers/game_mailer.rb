class GameMailer < ApplicationMailer 
  def move_error(user, game, errors)
    @user = user
    @message = errors.join(', ')
    @game = game

    mail to: @user.email, subject: build_subject('Error processing move!')
  end

  def notification(user, game, subject, message)
    @user = user
    @message = message
    @game = game

    mail to: @user.email, subject: build_subject(subject)
  end

  private

  def build_subject(subject)
    prefix = @game.present? ? "[Game #{@game.id}] " : ''
    "#{prefix}#{subject}"
  end
end
