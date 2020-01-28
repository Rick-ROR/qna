module Services
  class FindForOauth
    def self.call(auth)
      authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
      return authorization.user if authorization

      if auth.try(:info).try(:email).blank?
        return User.new
      else
        downcased_email = auth.info.email.downcase
        user = User.find_by(email: downcased_email)
      end

      User.transaction do
        unless user
          password = Devise.friendly_token[0, 20]
          user = User.create!(email: downcased_email, password: password, password_confirmation: password)
        end

        user.authorizations.create!(provider: auth.provider, uid: auth.uid.to_s)
      end

      user

    end
  end
end
