
require 'rails_helper'

feature 'User can mark the best answer of the question', %(
In order highlight the most usefull answer
As an anauthenticated user
I'd like to mark the the best answer
) do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer_1) { create(:answer, user: user, question: question) }

  describe 'Authenticated user as question author' do
    scenario 'ask a question' do
      sign_in(user)
      visit questions_path
      click_on 'Mark as the best answer'
      #  save_and_open_page
      expect(page).to have_content 'Best answer'
    end
  end

  describe 'Unauthenticated user asks a question with errors' do
    scenario 'cannot mark the best question' do
      expect(page).to_not have_content 'Mark as the best answer'
    end
  end

  describe 'Authenticated user that is NOT question author' do
    scenario 'cannot mark the best question' do
      sign_in(user_2)
      visit questions_path
      expect(page).to_not have_content 'Mark as the best answer'
    end
  end
end
