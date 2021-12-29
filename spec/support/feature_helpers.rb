module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in "Password", with: user.password
    click_on 'Log in'
  end

  def sign_out
    click_on 'Sign out'
  end

  def ask_question
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Ask'
  end

  def answer(question)
    visit question_path(question)
    fill_in 'answer_body', with: 'Test answer'
    click_on 'Add Answer'
  end

end
