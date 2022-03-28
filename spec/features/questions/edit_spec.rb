require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user_2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'delete file from question', js: true do
    sign_in user
    visit edit_question_path(question)
    #fill_in 'answer_body', match: :first, with: 'Test answer 3'
    attach_file 'File', ["#{Rails.root}/spec/support/files/questions/question.txt"], match: :first
    click_on 'Ask'
    click_on 'Delete File', match: :first
    expect(page).to_not have_link 'question.txt'
  end
end
