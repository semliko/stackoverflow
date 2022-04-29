require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, user: user_1) }
  let(:answer_1) { create(:answer, question: question, user: user_1) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user_1) }

    it 'populates an array of all questions' do
      get :index
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new Answer to @question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new Link to @answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user_1) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    before { login(user_1) }
    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user_1) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #update' do
    before { login(user_1) }
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do

      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user_1) }
    let!(:question) { create(:question, user: user_1) }
    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end

  describe 'POST #mark_best_answer' do
    before { login(user_1) }
    context 'with valid attributes' do
      it 'assignns answer as the best answer' do
        patch :mark_best_answer, params: { id: question.id, answer_id: answer_1.id }
        question.reload
        expect(question.best_answer).to eq answer_1
      end
    end
  end

  describe 'GET #show returns the best answer instance varible' do
    before do
      login(user_1)
      patch :mark_best_answer, params: { id: question.id, answer_id: answer_1.id }
      get :show, params: { id: question }
    end

    context 'when best answer exists' do
      it 'returns best anwser instance varible' do
        expect(assigns(:best_answer).id).to eq(answer_1.id)
      end

      it 'returns other anwers array without best_answer' do
        expect(assigns(:other_answers).ids).to_not include(answer_1.id)
      end
    end
  end
end
