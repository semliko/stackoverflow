require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    context 'authorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end
      it 'returns 401 status if access_token is invalid'
    end
  end
end
