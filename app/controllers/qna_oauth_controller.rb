class QnaOauthController < Devise::OmniauthCallbacksController

  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong, user 404'
    end
  end

  def vkontakte
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'VK') if is_navigational_format?
    else
      session['devise.oauth_provider'] = request.env['omniauth.auth']
      redirect_to oauth_adding_email_path
    end
  end

  def adding_email
  end

  def set_email
    if params["oauth_email"] !~ Devise.email_regexp
      redirect_to oauth_adding_email_path, alert: 'You entered the wrong email format!'
    else
      auth_hash = session['devise.oauth_provider'].merge!('info' => { 'email' => params["oauth_email"] } )
      User.find_for_oauth(OmniAuth::AuthHash.new(auth_hash))
      redirect_to root_path, alert: "Check #{params["oauth_email"]} and confirm your email address before continuing."
    end
  end
end
