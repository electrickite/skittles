class Move < ApplicationRecord
  ALGEBRAIC_PIECES = { pawn: '', bishop: 'B', knight: 'N', rook: 'R', queen: 'Q', king: 'K' }.freeze
  belongs_to :game

  before_create :set_number

  enum color: { white: 0, black: 1 }
  enum piece: { pawn: 0, bishop: 1, knight: 2, rook: 3, queen: 5, king: 6 }
  enum castle: { kingside: 0, queenside: 1 }
  enum promotion: { pawn_promotion: 0, bishop_promotion: 1, knight_promotion: 2,
                    rook_promotion: 3, queen_promotion: 5, king_promotion: 6 }

  validates :number, :color, :piece, :departure, :destination, presence: true
  validates :number, numericality: { only_integer: true }
  validates :number, uniqueness: { scope: :game }
  validates :color, inclusion: { in: colors.keys }
  validates :piece, inclusion: { in: pieces.keys }
  validates :castle, inclusion: { in: castles.keys }, allow_nil: true
  validates :promotion, inclusion: { in: promotions.keys }, allow_nil: true

  def to_s
    return 'O-O' if kingside?
    return 'O-O-O' if queenside?

    notation = "#{algebraic_piece}#{departure}#{'x' if capture}#{destination}"
    notation << "=#{promoted_piece}" if promotion

    if mate
      notation << '#'
    elsif check
      notation << '+'
    end

    notation
  end

  private

  def set_number
    self.number = game.moves.count + 1
  end

  def algebraic_piece
    ALGEBRAIC_PIECES[piece]
  end

  def promoted_piece
    return nil unless promotion
    promoted = promotion.to_s.split('_').first.to_sym
    ALGEBRAIC_PIECES[promoted]
  end
end
