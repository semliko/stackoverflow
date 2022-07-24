require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:user_1) { create(:user) }
  let(:question) { create(:question, user: user_1) }
  let(:question_2) { create(:question, user: user_1) }
  let(:answer) { create(:answer, question: question, user: user_1) }
  let(:answer_2) { create(:answer, question: question, user: user_2) }
  let(:answer_3) { create(:answer, question: question, user: user_3) }

  describe 'User searches for the answer', sphinx: true do
    let(:questions) { create_list(:question, 3, user: user_1, title: 'some text') }
    before do
      login(user_1)
      questions.each(&:save)
    end

    ThinkingSphinx::Test.run do
      it 'it returns search results' do
        get :index, params: { search: 'some' }
        expect(response).to render_template :index
      end
    end
  end
end
