class MoveMailer < ApplicationMailer 
  def move_error(user, game, message)
    @user = user
    @message = message
    @game = game

    prefix = @game.present? ? "[Game #{game.id}] " : ''
    mail(to: @user.email, subject: "#{prefix}Error processing move!")
  end
end
