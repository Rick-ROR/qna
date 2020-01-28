require 'rails_helper'

RSpec.describe OauthController, type: :controller do

  providers = Devise.omniauth_providers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  providers.each do |provider|

    describe provider.to_s.capitalize do
      let(:oauth_data) { OmniAuth::AuthHash.new(provider:
                                                  provider.to_s,
                                                uid: 5555,
                                                info: { email: "#{provider.to_s}@example.edu" })}
      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get provider
      end

      context 'user exists' do
        let!(:user) { create(:user) }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(User).to receive(:find_for_oauth).and_return(user)
          get provider
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        let!(:user) { build(:user, :unconfirmed) }

        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
          allow(User).to receive(:find_for_oauth)
          get provider
        end

        it 'redirect to adding email path' do
          expect(response).to redirect_to user_oauth_adding_email_path
        end

        it 'does not login user' do
          expect(subject.current_user).to_not be
        end

        it 'saves auth in session' do
          set_session[:'devise.oauth_provider'].to(oauth_data)
        end
      end
    end

  end
end
