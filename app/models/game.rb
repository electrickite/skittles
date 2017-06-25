class Game < ApplicationRecord
  RESULT_MAP = { '1-0' => 'white_win', '0-1' => 'black_win', '1/2-1/2' => 'draw', '*' => 'other'}.freeze

  has_many :players, dependent: :destroy
  belongs_to :owner, class_name: 'User', inverse_of: :owned_games, optional: true
  has_many :moves, -> { order 'number ASC' }, dependent: :destroy

  accepts_nested_attributes_for :players

  enum result: { other: 0, white_win: 1, black_win: 2, draw: 3 }

  validates :result, presence: true
  validates :result, inclusion: { in: results.keys }
  validates :players, length: { minimum: 2, maximum: 2 }

  delegate :board, :over?, :status, :active_player, to: :game

  def to_s
    name || "Game #{id}"
  end

  def white_player
    players.white.take
  end

  def black_player
    players.black.take
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
      #play_next if active_player == :black
    end

    GameChannel.broadcast_to(self, game: self, move: current_move)
  end

  def board_for(move)
    if move.is_a? Integer
      game[move]
    else
      game[moves.index(move)]
    end
  end

  def current_move
    moves.last
  end

  def num_moves
    moves.count
  end

  def attributes
    super.merge({ 'fenstring' => nil, 'num_moves' => nil, 'active_player' => nil })
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
