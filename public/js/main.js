import { Chess } from './chess.js'

let board, game, chessboard, status, moveStatus;

const config = {
  position: 'start',
  showNotation: true,
  draggable: true,
  dropOffBoard: 'snapback',
  snapbackSpeed: 200,
  snapSpeed: 50,
  onDrop: onDrop,
  onSnapEnd: onSnapEnd,
  onDragStart: onDragStart,
  onMouseoverSquare: onMouseoverSquare,
  onMouseoutSquare: onMouseoutSquare
};

const whiteSquareGrey = '#a9a9a9';
const blackSquareGrey = '#696969';

const colors = {
  w: 'White',
  b: 'Black'
};

const pieces = {
  p: 'pawn',
  n: 'knight',
  b: 'bishop',
  r: 'rook',
  q: 'queen',
  k: 'king'
};

const flags = {
  n: '',
  b: 'push',
  e: 'en passant captures',
  c: 'captures',
  p: 'promoted to',
  np: 'promoted to',
  pn: 'promoted to',
  k: 'kingside castle',
  q: 'queenside castle'
};

function onDrop(source, target) {
  removeGreySquares();

  let move = game.move({
    from: source,
    to: target,
    promotion: document.getElementById('promote').value
  });

  if (move == null) return 'snapback';
  updateUI();
}

function onSnapEnd() {
  board.position(game.fen());
}

function onDragStart(source, piece) {
  if (game.game_over()) return false;

  if ((game.turn() === 'w' && piece.search(/^b/) !== -1) ||
      (game.turn() === 'b' && piece.search(/^w/) !== -1)) {
    return false;
  }
}

function onMouseoverSquare(square, piece) {
  removeGreySquares();

  let moves = game.moves({
    square: square,
    verbose: true
  });
  if (moves.length === 0) return;

  greySquare(square);

  for (let i = 0; i < moves.length; i++) {
    greySquare(moves[i].to);
  }
}

function onMouseoutSquare(square, piece) {
  removeGreySquares();
}

function updateUI() {
  removeRedSquares();
  updateStatus();
  updateUrl();
}

function updateStatus() {
  if (game.in_check()) {
    let kingPosition = getKeyByValue(board.position(), game.turn() + 'K');
    redSquare(kingPosition);
  }

  let msg;
  if (game.in_checkmate()) {
    const prevColor = (game.turn() === 'w') ? 'Black' : 'White';
    msg = `Checkmate! ${prevColor} wins.`;
  } else if (game.in_stalemate()) {
    msg = 'Draw by stalemate.';
  } else if (game.in_threefold_repetition()) {
    msg = 'Draw by threefold repetition.';
  } else if (game.insufficient_material()) {
    msg = 'Draw by insufficient material.';
  } else if (game.in_check()) {
    msg = `${colors[game.turn()]} in check!`;
  } else {
    msg = `${colors[game.turn()]} to move`;
  }
  status.textContent = msg;

  moveStatus.textContent = getMoveText() ?? 'None';
}

function updateUrl(url) {
  history.pushState({}, '', url ?? getCurrentUrl());
  document.head.querySelector("[property~=og\\:image][content]").content = getImageUrl();
}

async function copyMove() {
  const moveText = getMoveText();
  let text = getCurrentUrl();
  if (moveText) {
    text = `${moveText}

` + text;
  }

  try {
    await navigator.clipboard.writeText(text);
  } catch (error) {
    console.error(error.message);
  }
}

function getMoveText() {
  const move = lastMove();
  let text = null;
  if (move) {
    if (move.flags.includes('k') || move.flags.includes('q')) {
      text = `${colors[move.color]} ${flags[move.flags]}`;
    } else if (move.flags.includes('p') && move.flags.includes('c')) {
      text = `${colors[move.color]} ${pieces[move.piece]} ${move.from} to ${move.to} ${flags['c']} ${pieces[move.captured]} ${flags['p']} ${pieces[move.promotion]}`;
    } else if (move.flags.includes('e') || move.flags.includes('c') || move.flags.includes('p')) {
      text = `${colors[move.color]} ${pieces[move.piece]} ${move.from} to ${move.to} ${flags[move.flags]} ${move.captured ? pieces[move.captured] : pieces[move.promotion]}`;
    } else {
      text = `${colors[move.color]} ${pieces[move.piece]} ${move.from} to ${move.to} ${flags[move.flags]}`;
    }
  }
  return text;
}

function getCurrentUrl() {
  const move = lastMove();
  const url = new URL(location);
  url.searchParams.set('fen', game.fen());
  if (move) {
    for (const key in move) {
      if (move[key]) {
        url.searchParams.set(key, move[key]);
      }
    }
  }
  return url;
}

function lastMove() {
  let move = {
    color: null,
    piece: null,
    from: null,
    to: null,
    flags: null,
    captured: null,
    promotion: null
  };
  const moves = game.history({verbose: true});
  const url = new URL(location);

  if (moves.length) {
    const gameMove = moves[moves.length - 1];
    for (const key in move) {
      move[key] = gameMove[key] ?? null;
    }
  } else if (url.searchParams.get('to')) {
    for (const key in move) {
      move[key] = url.searchParams.get(key);
    }
  } else {
    move = null;
  }
  return move;
}

function getImageUrl() {
  const url = new URL(document.head.querySelector("[property~=og\\:image][content]").content);
  url.searchParams.set('fen', game.fen());
  return url;
}

function greySquare(squareId) {
  let square = chessboard.querySelector('.square-' + squareId);

  let background = whiteSquareGrey;
  if (square.classList.contains('black-3c85d')) {
    background = blackSquareGrey;
  }

  square.style.backgroundColor = background;
}

function removeGreySquares(){
  chessboard.querySelectorAll('.square-55d63').forEach((el) => {
    el.style.backgroundColor = null;
  });
}

function redSquare(squareId) {
  let square = chessboard.querySelector('.square-' + squareId);
  square.classList.add('highlight-red-check');
}

function removeRedSquares() {
  chessboard.querySelectorAll('.square-55d63').forEach((el) => {
    el.classList.remove('highlight-red-check');
  });
}

function getKeyByValue(object, value) {
  return Object.keys(object).find(key => object[key] === value);
}

document.addEventListener('DOMContentLoaded', () => {
  game = new Chess();
  const params = new URL(document.location).searchParams;
  const fen = params.get('fen');
  if (fen) { game.load(fen); }

  board = Chessboard('chessboard', config);
  board.position(game.fen());
  chessboard = document.getElementById('chessboard');
  status = document.getElementById('status');
  moveStatus = document.getElementById('move');
  updateStatus();

  if (navigator.share) {
    document.getElementById('copy').textContent = 'Share';
  }

  document.getElementById('copy').addEventListener('click', () => {
    if (navigator.share) {
      navigator.share({
        title: 'New move',
        text: getMoveText(),
        url: getCurrentUrl()
      })
      .then(() => console.log('Successful share'))
      .catch(error => console.log('Error sharing:', error));
    } else {
      copyMove();
    }
  });

  document.getElementById('undo').addEventListener('click', () => {
    if (game.undo()) {
      updateUI();
      board.position(game.fen());
    } else {
      alert('Cannot undo!');
    }
    if (game.history().length == 0) {
      moveStatus.textContent = '--';
    }
  });

  document.getElementById('reset').addEventListener('click', () => {
    if (window.confirm('Are you sure you want to reset the board?')) {
      board.start(false);
      game.reset();
      removeRedSquares();
      updateUrl(window.location.pathname);
      updateStatus();
    }
  });

  chessboard.addEventListener('touchmove', (e) => {
    e.preventDefault();
  }, {passive: false});
});
