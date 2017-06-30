function Game(el) {
  this.el = $(el);
  this.board;
  this.type = this.el.data('type');
  this.active = this.el.data('active');
  this.id = this.el.data('id');
  this.locked = false;
  this.speed = 200;
  this.players = {
    white: this.el.data('white'),
    black: this.el.data('black')
  };
}

Game.prototype.colorMap = { w: 'white', b: 'black' };
Game.prototype.theme = '/images/chesspieces/default/{piece}.png';

Game.prototype.initBoard = function(fen, result) {
  if (this.type == 'game' && this.active) {
    var opts = {
      position: fen,
      draggable: this.ongoing(result),
      pieceTheme: this.theme,
      showErrors: false,
      moveSpeed: this.speed,
      onDragStart: this.dragCheck.bind(this),
      onDrop: this.sendMove.bind(this)
    };
  } else {
    var opts = {
      position: fen,
      draggable: false,
      pieceTheme: this.theme
    };
  }

  this.board = ChessBoard(this.el.attr('id'), opts);
};

Game.prototype.lock = function() {
  this.locked = true;
};

Game.prototype.unlock = function() {
  this.locked = false;
};

Game.prototype.dragCheck = function() {
  return ! this.locked;
};

Game.prototype.ongoing = function(result) {
  return result == 'other' ? true : false
};

Game.prototype.update = function(game, move) {
  var self = this,
      oldFen;

  if (this.board) {
    oldFen = this.board.fen();
    self.board.position(game.fenstring);
  } else {
    this.initBoard(game.fenstring, game.result);
  }

  var activePlayer = game.active_player.toLowerCase().replace(/\b[a-z]/g, function(letter) {
    return letter.toUpperCase();
  });

  $('.result-js').text(game.result);
  $('.completed_at-js').text(game.completed_at);
  $('.moves-js').text(game.num_moves);
  $('.active_player-js').text(activePlayer + "'s move");

  if (move && move.fenstring.split(' ')[0] != oldFen) {
    setTimeout(function() {
      if (move.checkmate) {
        alert('Checkmate!');
      } else if (move.check) {
        alert('Check!');
      }
    }, self.speed);
  }

  if (!game.completed_at) { this.unlock(); }
};

Game.prototype.fetch = function() {
  if (this.type == 'game') {
    this.fetchGame();
  } else {
    this.fetchMove();
  }
};

Game.prototype.fetchGame = function() {
  var self = this;

  $.get(Routes.game_path(this.id, {format: 'json'}), function(game) {
    self.update(game, game.current_move);
  });
};

Game.prototype.fetchMove = function() {
  var self = this;

  $.get(Routes.move_path(this.id, {format: 'json'}), function(move) {
    self.update(move);
  });
};

Game.prototype.sendMove = function(source, target, piece, newPosition, oldPosition) {
  var color = this.colorMap[piece.charAt(0)];

  if (source != target && target != 'offboard') {
    var self = this;
    self.lock();

    $.ajax({
      method: "POST",
      url: Routes.game_moves_path(self.id, {format: 'json'}),
      data: { move: { player_id: self.players[color], notation: source + target } }
    }).fail(function(data, status, error) {
      self.board.position(oldPosition);

      if (data.responseJSON && data.responseJSON.base instanceof Array) {
        var msg = data.responseJSON.base.join(', ');
      } else if (error == 'Forbidden') {
        var msg = 'You do not have permission to make that move!';
      } else {
        var msg = 'Unkown error!';
      }

      alert('Error: ' + msg);
      self.unlock();
    });
  }
};
