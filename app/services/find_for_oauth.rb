module Services
  class FindForOauth
    attr_reader :auth
    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      email = auth.info&.email&.downcase
      password = Devise.friendly_token[0, 20]

      return User.new(password: password, password_confirmation: password) unless email

      user = User.where(email: email).first

      unless user
        user = User.create!(email: email, password: password, password_confirmation: password)
      end

      user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
      user
    end
  end
end
