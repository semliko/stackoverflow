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

        it 'creates authorisation for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorisation with provider and uid' do
          user = User.find_for_oauth(auth)
          authorisation = user.authorizations.first

          expect(authorisation.provider).to eq auth.provider
          expect(authorisation.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234', info: { email: 'new@user.com' }) }

        it 'create new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)

          expect(user.email).to eq auth.info.email
        end

        it 'creates authorisation for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorisation with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
