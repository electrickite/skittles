// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require js-routes
//= require rails-ujs
//= require turbolinks
//= require chessboard
//= require bootstrap-show-password
//= require_tree .

$(document).on('turbolinks:load', function() {
  var $board = $('#board')

  if ($board.length) {
    var game = new Game($board[0]);
    game.fetch();

    if ($board.data('type') == 'game') {
      subscribeToGame(game);
    }
  }
});
