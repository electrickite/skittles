class Game < ApplicationRecord
  RESULT_MAP = { '1-0' => 'white_win', '0-1' => 'black_win', '1/2-1/2' => 'draw', '*' => 'other'}.freeze

  has_many :moves, inverse_of: :game, dependent: :destroy

  enum result: { other: 0, white_win: 1, black_win: 2, draw: 3 }

  validates :result, inclusion: { in: results.keys }

  delegate :board, :over?, :status, :active_player, to: :game

  def to_s
    name || id
  end

  def fenstring
    board.to_fen
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

    if over?
      end_game!
    else
      play_next if active_player == :black
    end
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
    moves.create(game_id: id, color: active_player, notation: best_move)
  end

  def best_move
    result = engine.analyze(fenstring, depth: 12).split("\n").last
    result.split(' ')[1]
  end

  def end_game!
    update result: RESULT_MAP[game.result], completed_at: Time.zone.now
  end
end
