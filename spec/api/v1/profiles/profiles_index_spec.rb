require 'rails_helper'

describe 'Profiles API INDEX', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }


  describe 'GET /api/v1/profiles' do

    let(:api_path) {  '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user_response) { json['users'].last }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it 'returns list of users' do
        expect(json['users'].size).to eq 3
      end

      it 'returns list doesn\'t include me' do
        expect(json['users']).to_not be_include(me)
      end

      it_behaves_like 'API return Pub Fields' do
        let(:fields) { %w[id email admin created_at updated_at] }
        let(:resource) { users.last }
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end

  end

end
