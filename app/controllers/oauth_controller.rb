class OauthController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def github
    create_auth
  end

  def vkontakte
    create_auth
  end

  private

  def create_auth
    oauth = request.env['omniauth.auth']
    @user = User.find_for_oauth(oauth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice,
                        :success,
                        kind: oauth.provider.to_s.capitalize ) if is_navigational_format?

    elsif @user&.email.blank?
      session['devise.oauth_provider'] = oauth
      redirect_to user_oauth_adding_email_path
    else
      redirect_to root_path, alert: 'Something went wrong, user 404'
    end
  end

end
