json.extract! game, :id, :name, :fenstring, :result, :completed_at, :created_at, :updated_at
json.current_move do
  json.partial! "moves/move", move: @game.current_move
end
json.url game_url(game, format: :json)
