require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:user_2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'answer with file', js: true do
      sign_in user
      visit question_path(question)
      fill_in 'answer_body', match: :first, with: 'Test answer 2'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], match: :first

      within '.answer-form' do
        click_on 'Save'
      end
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'delete file from answer', js: true do
      sign_in user
      visit question_path(question)
      fill_in 'answer_body', match: :first, with: 'Test answer 3'
      attach_file 'File', ["#{Rails.root}/spec/support/files/answers/answer.txt"], match: :first

      within '.answer-form' do
        click_on 'Save'
      end
      click_on 'Delete File', match: :first
      expect(page).to_not have_link 'answer.txt'
    end

    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answer-form' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end
      expect(page).to have_content 'MyText'
    end

    scenario "tries to edit other user's question", js: true do
      sign_in user_2
      visit question_path(question)
      expect(page).to_not have_content 'Edit'
    end
  end
end
