class User::EmailsController < ApplicationController
  skip_authorization_check

  def new
  end

  def create
    email = params["oauth_email"]
    user = User.new(email: email)

    if user.email_format_valid?
      auth_hash = session['devise.oauth_provider'].merge!('info' => { 'email' => email } )
      User.find_for_oauth(OmniAuth::AuthHash.new(auth_hash))
      redirect_to root_path, notice: "Check #{email} and confirm your email address before continuing."
    else
      redirect_to user_oauth_adding_email_path, alert: 'You entered the wrong email format!'
    end
  end

end
