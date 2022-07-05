require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many :answers }
    it { should belong_to(:user).class_name('User') }
    it { should belong_to(:best_answer).class_name('Answer').optional }
    it { should accept_nested_attributes_for :links }
    it { should accept_nested_attributes_for :awards }
    it { should have_many(:subscriptions).dependent(:delete_all) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'attached files' do
    it 'have many attached file' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'calls Services::Reputation#calculate' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
