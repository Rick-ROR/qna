module OmniauthHelpers
  def mock_auth_hash(provider, email_skip = false)

    auth_hash = {
      'provider' => provider.to_s,
      'uid' => '44318'
    }

    auth_hash['info'] = { 'email' => 'mockuser@example.edu' } unless email_skip

    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(auth_hash)
  end
end
