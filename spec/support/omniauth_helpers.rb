module OmniauthHelpers
  def mock_auth_hash(provider: , email: nil)

    auth_hash = {
      'provider' => provider,
      'uid' => rand(1000).to_s,
      'info' => OmniAuth::AuthHash::InfoHash.new(
        { 'email' => email }
      )
    }

    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(auth_hash)
  end
end

