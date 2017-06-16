class Game < ApplicationRecord
  has_many :moves, inverse_of: :game, dependent: :destroy

  enum result: { white_win: 0, black_win: 1, draw: 2, other: 3 }

  validates :result, inclusion: { in: results.keys }, allow_nil: true

  def to_s
    name || id
  end

  def fenstring
    game.current.to_fen
  end

  def normalize(move)
    game.move(move)
    normalized = game.moves.last
    game.rollback!
    normalized
  rescue
    false
  end

  def legal_move?(move)
    !! normalize(move)
  end

  def update_board!
    @game = nil
    moves.reset
    play_next if game.active_player == :black
  end

  def board_for(move)
    if move.is_a? Integer
      game[0]
    else
      game[moves.index(move)]
    end
  end

  private

  def game
    @game ||= Chess::Game.new(moves.map(&:notation))
  end

  def engine
    @engine ||= Stockfish::Engine.new(Rails.configuration.x.engine_path)
  end

  def play_next
    moves.create(game_id: id, color: game.active_player, notation: best_move)
  end

  def best_move
    result = engine.analyze(fenstring, depth: 12).split("\n").last
    result.split(' ')[1]
  end
end
