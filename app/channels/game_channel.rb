class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find(params[:id])
    stream_for @game
  end

  def unsubscribed
    # unsubscribe
  end
end
