import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(message) {
    var comments = $('.comments')
    comments.append(message)
    // Called when there's incoming data on the websocket for this channel
  }
});
