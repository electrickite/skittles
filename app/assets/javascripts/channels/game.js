function subscribeToGame(game) {
  App.game = App.cable.subscriptions.create({channel: "GameChannel", id: game.id}, {
    connected: function() {
      // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) {
      if (data.game) {
        game.update(data.game, data.move);
      }
    }
  });
}
