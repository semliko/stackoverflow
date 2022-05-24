require 'rails_helper'

RSpec.describe Award, type: :model do


  describe 'associations' do
    it { should belong_to(:awardable) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'attached files' do
    it 'have many attached file' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end
end
