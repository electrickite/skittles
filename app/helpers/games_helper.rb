module GamesHelper
  def player_link(player)
    if player.user
      link_to player, player.user
    else
      player
    end
  end

  def game_action_links(game, move)
    links = []
    links << link_to('New move', new_game_move_path(game)) if can?(:new, move)
    links << link_to('Edit', edit_game_path(game)) if can?(:uodate, game)
    links << link_to('Delete', game, method: :delete, data: { confirm: 'Are you sure?' }) if can?(:destroy, game)
    links.join(' | ').html_safe
  end
end
