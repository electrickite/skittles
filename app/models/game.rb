class Game < ApplicationRecord
  has_many :moves

  enum result: { white_win: 0, black_win: 1, draw: 2, other: 3 }

  validates :result, inclusion: { in: results.keys }, allow_nil: true

  def to_s
    name || id
  end
end
