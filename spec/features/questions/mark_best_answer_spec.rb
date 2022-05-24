
require 'rails_helper'

feature 'User can mark the best answer of the question', %(
In order highlight the most usefull answer
As an anauthenticated user
I'd like to mark the the best answer
) do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer_1) { create(:answer, user: user, question: question) }
  given(:badge_file) { "#{Rails.root}/spec/support/files/awards/star.png" }

  describe 'Authenticated user as question author' do
    scenario 'mark the best answer with award' do
      award = Award.new(name: 'test')
      question.awards.build(award.attributes).save
      question.awards.first.file.attach(io: File.open(badge_file), filename: 'star.png')
      answer_1.reload
      sign_in(user)
      visit question_path(question)
      click_on 'Mark as the best answer'
      #save_and_open_page
      expect(page).to have_content 'Best answer'
      expect(page).to have_css("img[src*='star.png']")
    end
  end

  describe 'Authenticated user that is NOT question author' do
    scenario 'cannot mark the best question' do
      sign_in(user_2)
      visit question_path(question)
      expect(page).to_not have_content 'Mark as the best answer'
    end
  end
end
