class Move < ApplicationRecord
  belongs_to :game, inverse_of: :moves

  before_create :set_number
  before_save :normalize_notation
  after_save :update_game

  enum color: { white: 0, black: 1 }

  validates :number, :color, :notation, presence: true
  validates :number, numericality: { only_integer: true }
  validates :number, uniqueness: { scope: :game }
  validates :color, inclusion: { in: colors.keys }
  validate :legal

  def to_s
    notation
  end

  delegate :insufficient_material?, :stalemate?, :checkmate?, :check?, to: :board
  alias_method :check, :check?
  alias_method :checkmate, :checkmate?

  def fenstring
    board.to_fen
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

  def board
    game.board_for self
  end
end
