class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable

  has_many :players, dependent: :nullify
  has_many :games, through: :players
  has_many :owned_games, class_name: 'Game', foreign_key: 'owner_id', dependent: :nullify, inverse_of: :owner
  has_many :moves, through: :players, inverse_of: :user

  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :username, :email, length: { maximum: 191 }

  delegate :can?, :cannot?, :authorize!, to: :ability

  def to_s
    username
  end

  def ability
    @ability ||= Ability.new(self)
  end
end
