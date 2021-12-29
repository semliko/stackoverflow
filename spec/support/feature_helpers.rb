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

end
