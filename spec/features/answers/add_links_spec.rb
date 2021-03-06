require 'rails_helper'

feature 'User can add links to answer', "
In order to provide additional info to my question
As an questio's author
I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/semliko/acb0417001b809849ae7807cd17fcb54' }

  scenario 'User adds link when provides answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: 'Test answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User can delete link from his answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer_body', with: 'Test answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add Answer'
    visit current_path

    within '.links_display' do
      click_on 'Delete link'
    end

    within '.answers' do
      expect(page).to_not have_link 'My gist', href: gist_url
    end
  end
end
