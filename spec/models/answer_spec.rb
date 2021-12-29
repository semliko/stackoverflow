require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'associations' do
    it { should belong_to(:question).class_name('Question') }
    it { should belong_to(:user).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :user }
    it { should validate_presence_of :question }
  end

end
