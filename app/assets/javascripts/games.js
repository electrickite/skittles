function Game(el) {
  this.el = $(el);
  this.board;
  this.type = this.el.data('type');
  this.id = this.el.data('id');
  this.locked = false;
  this.speed = 200;
  var self = this;

  if (this.type == 'game') {
    this.getGame(function(game) {
      self.initBoard({
        position: game.fenstring,
        draggable: self.ongoing(game.result),
        pieceTheme: self.theme,
        showErrors: false,
        moveSpeed: self.speed,
        onDragStart: self.dragCheck.bind(self),
        onDrop: self.sendMove.bind(self)
      });
    });
  } else {
    this.getMove(function(move) {
      console.log(move);
      self.initBoard({
        position: move.fenstring,
        draggable: false,
        pieceTheme: self.theme
      });
    });
  }
}

Game.prototype.colorMap = { w: 'white', b: 'black' };
Game.prototype.theme = '/images/chesspieces/wikipedia/{piece}.png';

Game.prototype.initBoard = function(opts) {
  this.board = ChessBoard(this.el.attr('id'), opts);
};

Game.prototype.getGame = function(callback) {
  $.get(Routes.game_path(this.id, {format: 'json'}), callback);
};

Game.prototype.getMove = function(callback) {
  $.get(Routes.move_path(this.id, {format: 'json'}), callback);
};

Game.prototype.lock = function() {
  this.locked = true;
};

Game.prototype.unlock = function() {
  this.locked = false;
};

Game.prototype.dragCheck = function() {
  return ! this.locked;
}

Game.prototype.ongoing = function(result) {
  return result == 'other' ? true : false
}

Game.prototype.sendMove = function(source, target, piece, newPosition, oldPosition) {
  var color = this.colorMap[piece.charAt(0)];

  if (source != target && target != 'offboard') {
    var self = this;
    self.lock();

    $.ajax({
      method: "POST",
      url: Routes.moves_path({format: 'json'}),
      data: { move: { game_id: self.id, color: color, notation: source + target } }
    }).done(function(msg) {
      self.getGame(function(game) {
        self.board.position(game.fenstring);
        $('.result-js').text(game.result);
        $('.completed_at-js').text(game.completed_at);

        setTimeout(function() {
          if (game.current_move.checkmate) {
            alert('Checkmate!');
          } else if (game.current_move.check) {
            alert('Check!');
          }
        }, self.speed);

        if (!game.completed_at) { self.unlock(); }
      });
    }).fail(function(data) {
      self.board.position(oldPosition);

      if (data.responseJSON && data.responseJSON.base instanceof Array) {
        var msg = data.responseJSON.base.join(', ');
      } else {
        var msg = 'Unkown error';
      }

      alert('Error: ' + msg);
      self.unlock();
    });
  }
};

$(document).on('turbolinks:load', function() {
  var $board = $('#board');
  if ($board.length) {
    new Game($board[0]);
  }
});
