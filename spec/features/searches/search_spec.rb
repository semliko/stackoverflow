require 'sphinx_helper'

feature 'User can search for questions answers and users', "
  In order to find needed object
  As a User
  I'd like to be able to search for content
" do
  # ...
  given(:user) { create(:user, email: 'user@email.com') }
  given(:question) { create(:question, user: user, title: 'some title') }
  given(:answer) { create(:aswer, user: user, qeustion: qeustion, body: 'some body') }

  scenario 'User searches for the qeustions', sphinx: true do
    sign_in(user)
    visit questions_path
    fill_in 'search', with: 'qeustions:Some title'

    click_on 'Search'

    ThinkingSphinx::Test.run do
      expect(page).to have_content 'some title'
    end
  end

  scenario 'User searches for the answers', sphinx: true do
    sign_in(user)
    visit questions_path
    fill_in 'search', with: 'answers:some body'

    click_on 'Search'

    ThinkingSphinx::Test.run do
      expect(page).to have_content 'some body'
    end
  end

  scenario 'User searches for the users', sphinx: true do
    sign_in(user)
    visit questions_path
    fill_in 'search', with: 'users:user@email.com'

    click_on 'Search'

    ThinkingSphinx::Test.run do
      expect(page).to have_content 'user@email.com'
    end
  end

  scenario 'User searches for all users, questions and answer together', sphinx: true do
    sign_in(user)
    visit questions_path
    fill_in 'search', with: 'some'

    click_on 'Search'

    ThinkingSphinx::Test.run do
      expect(page).to have_content 'some title'
      expect(page).to have_content 'some body'
    end
  end
end
