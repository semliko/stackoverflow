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
    it 'redirects to the toot path if user does not exist' do
      expect(User).to receive(:find_for_oauth)
      get :github

      expect(response).to redirect_to root_path
    end
  end
end
