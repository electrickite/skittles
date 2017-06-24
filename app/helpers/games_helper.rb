module GamesHelper
  def player_link(player)
    if player.user
      link_to player, player.user
    else
      player
    end
  end
end
