require 'rails_helper'

RSpec.describe Notification do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:subscription) { users.each { |u| create(:subscription, user: u, subscriwable: question) } }
  let(:subscribed_users) do
    User.joins(:subscriptions).where(subscriptions: { subscriwable_type: 'Question', subscriwable_id: question.id })
  end

  it 'notifies question author about a new answer' do
    expect(NotificationMailer).to receive(:new_answer_notification).with(author, answer).and_call_original
    subject.new_answer(author, answer)
  end

  it 'notifies all users subscribed to this question about a new answer' do
    subscribed_users.each do |user|
      expect(NotificationMailer).to receive(:new_answer_notification).with(user, answer).and_call_original
    end
    subject.new_answer(user, answer)
  end
end
