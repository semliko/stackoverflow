class Notification
  def new_answer(user, question)
    NotificationMailer.new_answer_notification(user, question).deliver_later
  end
end
