require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'Github' do
    it 'find user from auth data' do
      expect(User).to receive(:find_for_oauth)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to the toot path if user does not exist' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
