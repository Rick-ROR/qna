class QnaOauthController < Devise::OmniauthCallbacksController

  before_action :create_auth, only: [:github, :vkontakte]

  def github
  end

  def vkontakte
  end

  def adding_email
  end

  def set_email
    email = params["oauth_email"]
    user = User.new(email: email)

    if user.email_valid?
      auth_hash = session['devise.oauth_provider'].merge!('info' => { 'email' => email } )
      User.find_for_oauth(OmniAuth::AuthHash.new(auth_hash))
      redirect_to root_path, notice: "Check #{email} and confirm your email address before continuing."
    else
      redirect_to oauth_adding_email_path, alert: 'You entered the wrong email format!'
    end
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
      redirect_to oauth_adding_email_path
    else
      redirect_to root_path, alert: 'Something went wrong, user 404'
    end
  end

end
