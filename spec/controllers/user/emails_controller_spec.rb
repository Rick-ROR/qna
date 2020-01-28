require 'rails_helper'

RSpec.describe User::EmailsController, type: :controller do

  describe "GET #new" do
    it 'renders template :new' do
      expect(get :new).to render_template(:new)
    end
  end

  describe "POST #create" do
    before do
      session['devise.oauth_provider'] = { provider: 'vkontakte', uid: '105040' }
    end

    context 'with valid attributes' do
      let(:user) { build(:user, :unconfirmed) }
      let(:post_email) { post :create, params: { oauth_email: user.email } }

      it 'redirects to root path' do
        expect(post_email).to redirect_to root_path
      end

      it 'create user' do
        expect{post_email}.to change(User.where(email: user.email), :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:user) { build(:user, :unconfirmed) }
      let!(:post_email) { post :create, params: { oauth_email: '@@' } }

      it 'redirect to adding email path' do
        expect(response).to redirect_to user_oauth_adding_email_path
      end

      it 'does not create user' do
        expect { :post_email }.to_not change(User, :count)
      end
    end
  end

end
