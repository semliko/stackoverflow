require 'sphinx_helper'

feature 'User can search for answer', "
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer
" do
  # ...

  scenario 'User searches for the answer', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      # test
    end
  end
end
