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
      it 'returns user' do
        user.authorizations.create(provider: 'facebook', uid: '1234')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorisation' do
      context 'user alredy exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234', info: { email: user.email }) }
        it 'does not create a new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end
      end
    end
  end
end
