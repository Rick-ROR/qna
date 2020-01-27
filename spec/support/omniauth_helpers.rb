module OmniauthHelpers
  def mock_auth_hash(provider, email_skip = false)

    auth_hash = {
      'provider' => provider.to_s,
      'uid' => rand(1000).to_s,
      'info' => OmniAuth::AuthHash::InfoHash.new(
        { 'email' => "mockuser_#{provider.to_s}@example.edu" }
      )
    }

    auth_hash['info'] = {} if email_skip

    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(auth_hash)
  end
end

