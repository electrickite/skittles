class Move < ApplicationRecord
  belongs_to :game

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
end
