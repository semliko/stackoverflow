require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, user: user_1) }
  let(:answer) { create(:answer, question: question, user: user_1) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3, question: question, user: user_1) }

    it 'populates an array of all answers' do
      get :index, params: { question_id: question }
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      get :index, params: { question_id: question }
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { question_id: question, id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    context 'as an author of the question' do
      before { login(user_1) }
      before { get :edit, params: { id: answer, question_id: question } }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      before { login(user_1) }
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, user_id: user_1, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
        expect { post :create, params: { question_id: question, user_id: user_1, answer: attributes_for(:answer) }, format: :js }.to change(user_1.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user_1) }
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js}
        expect(response).to render_template :create
      end
    end
  end



  describe 'POST #update' do
    context 'as an author of the question' do
      before { login(user_1) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'redirects to question path' do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do

        before { patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }
        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq 'MyText'
        end

        it 'redirects to question_path' do
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'as NOT an author of the question' do
      before { sign_out(user_1) }
      before { login(user_2) }
      it 'NOT changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end

      it 'redirects to question path' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as an author of the question' do
      before { login(user_1) }

      let!(:answer) { create(:answer, question: question, user: user_1) }
      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'as NOT an author of the question' do
      before { sign_out(user_1) }
      before { login(user_2) }

      let!(:answer) { create(:answer, question: question, user: user_1) }
      it 'cannot delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(question.answers, :count).by(0)
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

end
