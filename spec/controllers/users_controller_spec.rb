require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user_1) { create(:user) }

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: user_1.id }
      expect(response).to have_http_status(:success)
    end
  end

end
