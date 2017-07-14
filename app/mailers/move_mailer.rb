class MoveMailer < ApplicationMailer 
  def move_error(user, game, errors)
    @user = user
    @message = errors.join(', ')
    @game = game

    prefix = @game.present? ? "[Game #{game.id}] " : ''
    mail(to: @user.email, subject: "#{prefix}Error processing move!")
  end
end
