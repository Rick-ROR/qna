module OmniauthHelpers
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      'provider' => 'github',
      'uid' => '44318',
      'info' => {
        'email' => 'mockuser@example.edu'
      }
    )
  end
end
