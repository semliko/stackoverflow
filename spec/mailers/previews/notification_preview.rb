# Preview all emails at http://localhost:3000/rails/mailers/notification
class NotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification/new_answer_notification
  def new_answer_notification
    NotificationMailer.new_answer_notification
  end

end
