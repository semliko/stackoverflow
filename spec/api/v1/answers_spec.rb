require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/question:id/answers' do
    context 'unauthorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, user: user) }
      let!(:anwers) { create_list(:answer, 2, user: user, question: question) }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: 123 }, headers: headers
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH /api/v1/anwers' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question, user: user) }
    let(:anwers) { create_list(:answer, 2, user: user, question: question) }
    let(:answer) { anwers.first }
    let(:questions_response) { JSON.parse(response.body) }

    before do
      access_token.update(resource_owner_id: user.id)
    end

    context 'authorized autor of the answer' do
      it 'can update his answer' do
        patch "/api/v1/answers/#{answer.id}",
              params: { id: answer, access_token: access_token.token,
                        answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question, user: user) }

    before do
      access_token.update(resource_owner_id: user.id)
    end

    context 'authorized user' do
      it 'can create a new question' do
        expect do
          post "/api/v1/questions/#{question.id}/answers",
               params: { access_token: access_token.token, user_id: user.id, qeustion_id: question.id,
                         answer: { body: 'new body' } }
        end.to change(Answer, :count).by(1)
      end
    end
  end

  describe 'DELETE /api/v1/answers' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    before do
      access_token.update(resource_owner_id: user.id)
    end

    context 'authorized user' do
      it 'can delete a  answer' do
        delete "/api/v1/answers/#{answer.id}",
               params: { access_token: access_token.token, user_id: user.id, id: answer.id, qeustion_id: question.id }
        expect(Answer.count).to eq 0
      end
    end
  end
end
