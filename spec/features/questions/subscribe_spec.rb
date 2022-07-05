require 'rails_helper'

feature 'User can subscribe', %(
In order to get notification about new answer
As an anauthenticated user
I'd like to be able to subscribe for the question notifications
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'
    end

    scenario 'subscribtion link' do
      visit question_path(question)
      expect(page).to have_content 'Subscribe'
    end

    scenario 'subscribe for notifications' do
      click_on 'Subscribe'
      #  save_and_open_page
      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'unsubscribe from notifications' do
      click_on 'Subscribe'
      #  save_and_open_page
      expect(page).to have_content 'Subscribe'
    end
  end

  scenario 'Unauthenticated user cannot subscribe ' do
    visit question_path(question)

    expect(page).not_to have_content 'Subscribe'
  end
end
