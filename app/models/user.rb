class User < ApplicationRecord
  NOTIFICATION_METHODS = ['email', 'sms'].freeze
  PLAY_METHODS = ['email', 'sms'].freeze

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable

  before_save :clean_serialized_arrays
  before_save :null_play_token

  has_many :players, dependent: :nullify
  has_many :games, through: :players
  has_many :owned_games, class_name: 'Game', foreign_key: 'owner_id', dependent: :nullify, inverse_of: :owner
  has_many :moves, through: :players, inverse_of: :user

  serialize :notification_preference, Array
  serialize :play_methods, Array

  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :username, :email, length: { maximum: 191 }
  validate :play_methods_allowed, :notification_preferences_allowed

  delegate :can?, :cannot?, :authorize!, to: :ability

  def to_s
    username
  end

  def ability
    @ability ||= Ability.new(self)
  end

  def notify_email?
    notification_preference.include? 'email'
  end

  def notify_sms?
    notification_preference.include? 'sms'
  end

  private

  def clean_serialized_arrays
    notification_preference.reject! { |p| p.blank? }
    play_methods.reject! { |m| m.blank? }
  end

  def null_play_token
    play_token = nil if play_token.blank?
  end

  def play_methods_allowed
    (play_methods - PLAY_METHODS).each do |method|
      errors.add(:play_methods, "#{method} is not a valid play method")
    end
  end

  def notification_preferences_allowed
    (notification_preference - NOTIFICATION_METHODS).each do |method|
      errors.add(:notification_preference, "#{method} is not a valid notification method")
    end
  end
end
