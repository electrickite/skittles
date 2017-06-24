json.partial! "games/game", game: @game

if @game.current_move
  json.current_move do
    json.partial! "moves/move", move: @game.current_move
  end
end
