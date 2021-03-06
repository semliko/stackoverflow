require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: 123 }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorised' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { JSON.parse(response.body).first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        json = JSON.parse(response.body)
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        json = JSON.parse(response.body)
        expect(json.size).to eq 2
      end

      it 'does not returns all public fields' do
        json = JSON.parse(response.body)
        %w[id title body user created_at updated_at].each do |attr|
          expect(json.first[attr]).to eq questions.first.send(attr).as_json
        end
      end

      it 'returns user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answers_response) { JSON.parse(response.body).first['answers'] }

        let(:answer) { answers.first }

        it 'returns list of answers' do
          expect(answers_response.size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answers_response.first[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:questions) { create_list(:question, 2, user: user) }
    let(:question) { questions.first }
    let(:questions_response) { JSON.parse(response.body) }

    before do
      questions.each(&:save!)
      access_token.update(resource_owner_id: user.id)
    end

    context 'authorized autor of the question' do
      it 'can update his question' do
        patch "/api/v1/questions/#{question.id}",
              params: { id: question, access_token: access_token.token,
                        question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }

    before do
      access_token.update(resource_owner_id: user.id)
    end

    context 'authorized user' do
      it 'can create a new question' do
        expect do
          post '/api/v1/questions',
               params: { access_token: access_token.token, user_id: user.id,
                         question: { title: 'new title', body: 'new body' } }
        end.to change(Question, :count).by(1)
      end
    end
  end

  describe 'DELETE /api/v1/questions' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question, user: user) }

    before do
      access_token.update(resource_owner_id: user.id)
    end

    context 'authorized user' do
      it 'can create a new question' do
        delete "/api/v1/questions/#{question.id}",
               params: { access_token: access_token.token, user_id: user.id, id: question.id }
        expect(Question.count).to eq 0
      end
    end
  end
end
