require 'rails_helper'

RSpec.describe QnaOauthController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "Github" do
    let(:oauth_data) { {'provider' => 'github', 'uid' => '794'} }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does no exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end

  end

  describe "VK" do
    let(:oauth_data) { {'provider' => 'vkontakte', 'uid' => '7945', info: { email: 'new@mail.com' }} }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does no exist' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirect to adding email path' do
        expect(response).to redirect_to oauth_adding_email_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end

      it 'saves auth in session' do
        set_session[:'devise.oauth_provider'].to(oauth_data)
      end
    end

  end

  describe "get #adding_email" do
    it 'renders template :adding_email' do
      expect(get :adding_email).to render_template(:adding_email)
    end
  end

  describe "post #set_email" do
    before do
      session['devise.oauth_provider'] = { provider: 'vkontakte', uid: '105040' }
    end

    context 'with valid attributes' do
      let(:user) { build(:user, :unconfirmed) }
      let(:post_email) { post :set_email, params: { oauth_email: user.email } }

      it 'redirects to root path' do
        expect(post_email).to redirect_to root_path
      end

      it 'create user' do
        expect{post_email}.to change(User, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:user) { build(:user, :unconfirmed) }
      let!(:post_email) { post :set_email, params: { oauth_email: '' } }

      it 'redirect to adding email path' do
        expect(response).to redirect_to oauth_adding_email_path
      end

      it 'does not create user' do
        expect { :post_email }.to_not change(User, :count)
      end
    end
  end
end
