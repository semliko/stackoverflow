require 'rails_helper'

RSpec.describe Answer, type: :model do

  describe 'associations' do
    it { should belong_to(:question).class_name('Question') }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

end
