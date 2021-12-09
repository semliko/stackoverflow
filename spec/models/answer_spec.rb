require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'fields' do
    it { should validate_presence_of :body }
  end

  describe 'associations' do
    it { should belong_to(:question).class_name('Question') }
  end

end
