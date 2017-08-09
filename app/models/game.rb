class Game < ApplicationRecord
  RESULT_MAP = { '1-0' => 'white_win', '0-1' => 'black_win', '1/2-1/2' => 'draw', '*' => 'other'}.freeze

  has_many :players, dependent: :destroy
  has_many :human_players, -> { where.not user: nil }, class_name: 'Player'
  belongs_to :owner, class_name: 'User', inverse_of: :owned_games, optional: true
  has_many :moves, -> { order 'number ASC' }, dependent: :destroy

  after_create :send_new_game_notification

  accepts_nested_attributes_for :players

  enum result: { other: 0, white_win: 1, black_win: 2, draw: 3 }

  validates :result, presence: true
  validates :result, inclusion: { in: results.keys }
  validates :players, length: { minimum: 2, maximum: 2 }

  delegate :board, :over?, :status, to: :game

  def to_s
    name || "Game #{id}"
  end

  def to_pos
    board.to_s.gsub(/\e\[(\d+)m/, '')
  end

  def active_color
    game.active_player
  end

  def white_player
    players.white.take
  end

  def black_player
    players.black.take
  end

  def active_player
    self.send "#{active_color}_player"
  end

  def winner
    if white_win?
      white_player
    elsif black_win?
      black_player
    end
  end

  def watchers
    (human_players.map {|p| p.user} << owner).uniq
  end

  def fenstring
    board.to_fen
  end

  def ongoing?
    !over?
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

    end_game! if over?
    send_updates
    play(best_move) if ongoing? && active_player.ai?
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

  def play(notation)
    build_next_move(notation).save!
  end

  def build_next_move(notation)
    moves.build(player: active_player, notation: notation)
  end

  def attributes
    super.merge({ 'fenstring' => nil, 'num_moves' => nil, 'active_color' => nil })
  end

  private

  def game
    @game ||= Chess::Game.new(moves.map(&:notation))
  end

  def engine
    @engine ||= Stockfish::Engine.new(Rails.configuration.x.engine_path)
  end

  def best_move
    result = engine.analyze(fenstring, depth: 12).split("\n").last
    result.split(' ')[1]
  end

  def end_game!
    update result: RESULT_MAP[game.result], completed_at: Time.zone.now
  end

  def send_new_game_notification
    NotificationService.new(self).new_game
  end

  def send_updates
    GameChannel.broadcast_to(self, game: self, move: current_move)
    NotificationService.new(self).new_move
    NotificationService.new(self).game_over if over?
  end
end
