require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:user_3) { create(:user) }
  let(:question) { create(:question, user: user_1) }
  let(:answer) { create(:answer, question: question, user: user_1) }
  let(:answer_2) { create(:answer, question: question, user: user_2) }
  let(:answer_3) { create(:answer, question: question, user: user_3) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user_1) }
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { question_id: question, user_id: user_1, answer: attributes_for(:answer) },
                        format: :js
        end.to change(question.answers, :count).by(1)
        expect do
          post :create, params: { question_id: question, user_id: user_1, answer: attributes_for(:answer) },
                        format: :js
        end.to change(user_1.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      before { login(user_1) }
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) },
                        format: :js
        end.to_not change(question.answers, :count)
      end
    end
  end

  describe 'POST #upvote' do
    before { login(user_1) }
    context 'with valid attributes' do
      it 'adding upvote to question' do
        patch :make_vote, params: { id: answer.id, vote: { vote_type: :upvote } }, format: :json
        answer.reload
        expect(answer.votes.upvote.count).to eq 1
      end
    end
  end

  describe 'POST #downvote' do
    before { login(user_1) }
    context 'with valid attributes' do
      it 'adding upvote to question' do
        patch :make_vote, params: { id: answer.id, vote: { vote_type: :downvote } }, format: :json
        answer.reload
        expect(answer.votes.downvote.count).to eq 1
      end
    end
  end

  describe 'POST #update' do
    context 'as an author of the question' do
      before { login(user_1) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to eq 'new body'
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) },
                         format: :js
        end
        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq 'MyText'
        end
      end
    end

    context 'as NOT an author of the question' do
      before { sign_out(user_1) }
      before { login(user_2) }
      it 'NOT changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as an author of the answer' do
      before { login(user_1) }

      let!(:answer) { create(:answer, question: question, user: user_1) }
      it 'deletes the answer' do
        expect do
          delete :destroy, params: { question_id: question, id: answer }
        end.to change(question.answers, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'as NOT an author of the answer' do
      before { sign_out(user_1) }
      before { login(user_2) }

      let!(:answer) { create(:answer, question: question, user: user_1) }
      it 'cannot delete the answer' do
        expect do
          delete :destroy, params: { question_id: question, id: answer }
        end.to change(question.answers, :count).by(0)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to root_path
      end
    end
  end
end
