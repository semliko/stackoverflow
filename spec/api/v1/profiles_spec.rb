require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: 123 }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorised' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        json = JSON.parse(response.body)

        %w[id email admin].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns all public fields' do
        json = JSON.parse(response.body)

        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', headers: headers
        expect(response.status).to eq 401
      end

      context 'authorised' do
        let(:users) { create_list(:user, 3) }
        let(:access_token) { create(:access_token, resource_owner_id: users.first.id) }

        before do
          get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns list of profiles' do
          json = JSON.parse(response.body)
          expect(json.size).to eq 3
        end
      end
    end
  end
end
