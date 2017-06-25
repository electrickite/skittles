json.extract! game, :id, :name, :fenstring, :result, :num_moves, :active_player, :completed_at, :created_at, :updated_at
json.url game_url(game, format: :json)
