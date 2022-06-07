import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(message) {
    console.log(message)
    var questions = $('.questions')
    questions.append(message)
    // Called when there's incoming data on the websocket for this channel
  }
});
