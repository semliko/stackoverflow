
require 'rails_helper'

feature 'User can create answer', %(
In order to provide an answer to the community
As an anauthenticated user
I'd like to be able to add an answer
) do

  given(:user_1) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, user: user_1) }

  describe 'Authenticated user' do

    background do
      sign_in(user_1)

      visit question_path(question)
    end

    scenario 'ask a question', js: true do
      fill_in 'answer_body', with: 'Test answer'
      click_on 'Add Answer'

      expect(page).to have_content 'Test answer'
    end

    scenario 'Authenticated user creates answer with errors', js: true do
      visit question_path(question)

      click_on 'Add Answer'

      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario 'Unauthenticated user create answer  with errors', js: true do
    visit question_path(question)
    # save_and_open_page
    fill_in 'answer_body', with: 'Test answer'
    click_on 'Add Answer'

    expect(page).to_not have_content 'Test answer'
  end
end
