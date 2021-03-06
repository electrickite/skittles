class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    # Guest user (not logged in)
    @user = user

    alias_action :create, :read, :update, :destroy, to: :crud

    add_common_abilities
    add_user_abilities if user
  end

  private

  def add_common_abilities
    can :read, :all
  end

  def add_user_abilities
    can :create, Game
    can :play, Game, players: { user_id: user.id }
    can :crud, Game, owner_id: user.id

    can :update, Player, game: { owner_id: user.id }

    can :create, Move, player: { user_id: user.id }

    can :destroy, User, id: user.id

    can :play_via, :sms if user.play_methods.include?('sms')
    can :play_via, :email if user.play_methods.include?('email')

    can :play_using_token, String do |token|
      user.play_token == token
    end
  end
end
