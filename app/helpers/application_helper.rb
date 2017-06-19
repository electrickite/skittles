module ApplicationHelper
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
