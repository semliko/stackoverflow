require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :answers }
  it { should have_many :questions }
  it { should have_many :awards }
  it { should have_many :votes }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234') }

    context 'user alredy has authorisation' do
      it 'returns user'
      user.authorization.create(provider: 'facebook', uid: '1234')
      expect(User.find_for_oauth(auth)).to eq user
    end
  end
end
