class Player < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :game
  has_many :moves, -> { order 'number ASC' }

  enum color: { white: 0, black: 1 }

  validates :color, presence: true
  validates :color, inclusion: { in: colors.keys }

  def to_s
    user ? user.username : 'AI'
  end
end
