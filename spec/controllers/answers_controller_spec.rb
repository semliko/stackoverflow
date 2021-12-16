require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3, question: question) }

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
    before { get :edit, params: { id: answer, question_id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end
end
