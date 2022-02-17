

require 'rails_helper'

feature 'User can delete his answer', %(
In order to remove an answer created earlier
As an anauthenticated user
Other users cannot delete my answers
) do

  given(:user_1) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, user: user_1) }

  describe 'Authenticated user_1' do

    background do
      sign_in(user_1)
      answer(question)
    end

    scenario 'delete his answer', js: true do
      # save_and_open_page
      visit question_path(question)
      accept_alert do
        click_on 'Destroy'
      end

      expect(page).to_not have_content 'Test answer'
    end
  end

  describe 'Authenticated user_2' do
    background do
      sign_in(user_1)
      answer(question)
      sign_out
      sign_in(user_2)
    end

    scenario 'cannot delete user_1 answers', js: true do
      visit question_path(question)
      #save_and_open_page

      expect(page).to_not have_content 'Destroy'
    end
  end
end
