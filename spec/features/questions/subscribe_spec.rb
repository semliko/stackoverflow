require 'rails_helper'

feature 'User can subscribe', %(
In order to get notification about new answer
As an anauthenticated user
I'd like to be able to subscribe for the question notifications
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:user_2) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user_2)
    end

    scenario 'subscribtion link' do
      visit question_path(question)
      expect(page).to have_content 'Subscribe'
    end

    #    scenario 'subscribe for notifications' do
    #      visit question_path(question)
    #      click_on 'Subscribe'
    #      # save_and_open_page
    #      visit question_path(question)
    #      expect(page).to have_content 'Unsubscribe'
    #    end

    scenario 'unsubscribe from notifications' do
      visit question_path(question)
      click_on 'Subscribe'
      visit question_path(question)
      # save_and_open_page
      click_on 'Unsubscribe'
      visit question_path(question)
      expect(page).to have_content 'Subscribe'
    end
  end

  scenario 'Unauthenticated user cannot subscribe ' do
    visit question_path(question)

    expect(page).not_to have_content 'Subscribe'
  end
end
