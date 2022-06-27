class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_foth_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    end
  end
end
