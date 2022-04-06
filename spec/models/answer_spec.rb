require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'associations' do
    it { should belong_to(:question).class_name('Question') }
    it { should belong_to(:user).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'attached files' do
    it 'have many attached file' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end
end
