module ApplicationHelper
  def flash_class(level)
    case level.to_sym
      when :notice then "alert-info"
      when :success then "alert-success"
      when :error then "alert-error"
      when :alert then "alert-error"
    end
  end

  def piece_image_path(piece)
    cap_piece = piece.capitalize
    color = piece === cap_piece ? 'w' : 'b'
    "/images/chesspieces/default/#{color}#{cap_piece}.png"
  end

  def square_color_class(color)
    if color == :white || color == 'black-3c85d'
      'white-1e1d7'
    else
      'black-3c85d'
    end
  end
end
