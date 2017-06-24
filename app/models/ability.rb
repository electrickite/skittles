class Ability
  include CanCan::Ability

  def initialize(user)
    # Guest user (not logged in)
    user ||= User.new

    can :read, :all

    can :manage, Game, owner_id: user.id

    can :update, Player, game: { owner_id: user.id }

    can :new, Move, game: { players: { user_id: user.id } }
    can :create, Move, player: { user_id: user.id }

    can :destroy, User, id: user.id
  end
end
