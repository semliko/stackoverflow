
require 'rails_helper'

feature 'User can create answer', %(
In order to provide an answer to the community
As an anauthenticated user
I'd like to be able to add an answer
) do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Add Answer'
    end

    scenario 'ask a question' do
      fill_in 'answer_body', with: 'Test answer'
      click_on 'Add Answer'

      expect(page).to have_content 'Test answer'
    end

  end

  scenario 'Unauthenticated user create answer  with errors' do
    visit question_path(question)
    # save_and_open_page
    fill_in 'answer_body', with: 'Test answer'
    click_on 'Add Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
