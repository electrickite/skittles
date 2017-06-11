var board,
    gameId = $('#board').data('game'),
    colorMap = { w: 'white', b: 'black' },
    pieceMap = { P: 'pawn', B: 'bishop', N: 'knight', R: 'Rook', Q: 'Queen', K: 'King' },
    boardLocked = false;

$(document).on('turbolinks:load', function() {
  if ($('#board').length) {
    $.get(Routes.game_path(gameId, {format: 'json'}), function(data) {
      console.log(data);
      board = ChessBoard('board', {
        position: data.fenstring,
        draggable: true,
        pieceTheme: '/images/chesspieces/wikipedia/{piece}.png',
        showErrors: false,
        onDragStart: dragCheck,
        onDrop: sendMove
      });
    });
  }
});

function sendMove(source, target, piece, newPosition, oldPosition) {
  var color = colorMap[piece.charAt(0)],
      piece = pieceMap[piece.charAt(1)];

  if (source != target && target != 'offboard') {
    boardLocked = true;

    $.ajax({
      method: "POST",
      url: Routes.moves_path({format: 'json'}),
      data: { move: { game_id: gameId, departure: source, destination: target, color: color, piece: piece } }
    }).done(function(msg) {
      // Do things...
    }).fail(function(data) {
      board.position(oldPosition);
      if (data.responseJSON && data.responseJSON.base instanceof Array) {
        var msg = data.responseJSON.base.join(', ');
      } else {
        var msg = 'Unkown error';
      }
      alert('Error: ' + msg);
    }).always(function() {
      boardLocked = false;
    });
  }
}

function dragCheck() {
  return ! boardLocked;
}
