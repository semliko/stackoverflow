require 'rails_helper'

RSpec.describe AuthServices::FindForOauth do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234') }
  subject { AuthServices::FindForOauth.new(auth) }

  context 'user alredy has authorisation' do
    it 'returns user' do
      user.authorizations.create(provider: 'facebook', uid: '1234')
      service = AuthServices::FindForOauth.new(auth)
      expect(subject.call).to eq user
    end
  end

  context 'user has not authorisation' do
    context 'user alredy exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234', info: { email: user.email }) }
      it 'does not create a new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates authorisation for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorisation with provider and uid' do
        user = subject.call
        authorisation = user.authorizations.first

        expect(authorisation.provider).to eq auth.provider
        expect(authorisation.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234', info: { email: 'new@user.com' }) }

      it 'create new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills user email' do
        user = subject.call

        expect(user.email).to eq auth.info.email
      end

      it 'creates authorisation for user' do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorisation with provider and uid' do
        authorization = subject.call.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
