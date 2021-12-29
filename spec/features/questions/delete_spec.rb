
require 'rails_helper'

feature 'User can delete his question', %(
In order to remove question created earlier
As an anauthenticated user
I'd like to be able to delete the quetion
Only me can delete my questions
) do

  given(:user_1) { create(:user) }
  given(:user_2) { create(:user) }

  describe 'Authenticated user_1' do

    background do
      sign_in(user_1)
      ask_question
    end

    scenario 'delete his question' do
      visit questions_path
      click_on 'Destroy'
      expect(page).to_not have_content 'Test question'
    end

    #  save_and_open_page
  end

  describe 'Authenticated user_2' do
    background do
      sign_in(user_1)
      ask_question
      sign_out
      sign_in(user_2)
    end

    scenario 'cannot delete user_1 questions' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to_not have_content 'Destroy'
    end
  end
end
