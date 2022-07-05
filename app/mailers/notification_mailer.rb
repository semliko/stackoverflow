class NotificationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.new_answer_notification.subject
  #
  def new_answer_notification(user, question)
    @question = question

    mail to: user.email
  end
end
