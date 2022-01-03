
require 'rails_helper'

feature 'User can sign out', %(
In order to exit from his account) do

  given(:user) { create(:user) }

  background do
    sign_in(user)
  end

  scenario 'Logged in tries to sign out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end

