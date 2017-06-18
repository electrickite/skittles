class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find(params[:id])
    stream_for @game
    transmit game: @game, move: @game.current_move
  end

  def unsubscribed
    # unsubscribe
  end
end
