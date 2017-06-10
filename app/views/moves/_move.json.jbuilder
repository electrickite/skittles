json.extract! move, :id, :game_id, :number, :color, :piece, :departure, :destination, :capture, :castle, :promotion, :check, :mate, :created_at, :updated_at
json.url move_url(move, format: :json)
