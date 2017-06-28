class Move < ApplicationRecord
  belongs_to :game
  belongs_to :player
  has_one :user, through: :player, inverse_of: :moves

  before_create :set_number
  before_save :normalize_notation
  after_save :update_game

  scope :for_game, ->(game) { where(game: game) }

  validates :number, :notation, presence: true
  validates :number, numericality: { only_integer: true }
  validates :number, uniqueness: { scope: :game }
  validate :legal

  def to_s
    notation
  end

  delegate :color, to: :player
  delegate :insufficient_material?, :stalemate?, :checkmate?, :check?, to: :board

  alias_method :check, :check?
  alias_method :checkmate, :checkmate?

  def fenstring
    board.to_fen
  end

  def board
    game.board_for self
  end

  def next
    self.class.where("game_id = ? AND number > ?", game_id, number).order(number: :asc).first
  end

  def previous
    self.class.where("game_id = ? AND number < ?", game_id, number).order(number: :asc).last
  end

  private

  def set_number
    self.number = game.moves.count + 1
  end

  def normalize_notation
    self.notation = game.normalize notation
  end

  def legal
    errors.add(:base, "Illegal move") unless game.legal_move?(self.to_s)
  end

  def update_game
    game.update_board!
  end

  def attributes
    super.merge({ 'fenstring' => nil, 'check' => nil, 'checkmate' => nil })
  end
end
