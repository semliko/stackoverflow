require 'rails_helper'

feature 'User can create question', %(
In order to get answer from a community
As an anauthenticated user
I'd like to be able to ask the quetion
) do

  given(:user) { create(:user) }
  given(:badge_file) { "#{Rails.root}/spec/support/files/awards/star.png" }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'ask a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'ask a question with errors' do
      click_on 'Ask'
      #  save_and_open_page
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'ask a question with file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'ask a question with award' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      #save_and_open_page
      fill_in 'Award name', with: 'Test Award'
      attach_file 'Award badge', badge_file
      click_on 'Ask'
      binding.pry
      expect(page).to have_css("img[src*='star.png']")
    end
  end


  scenario 'Unauthenticated user asks a question with errors' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
