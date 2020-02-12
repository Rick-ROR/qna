require 'rails_helper'

describe 'Answers API DELETE', type: :request do

  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, author: author) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'answers author/admin' do
        let(:access_token) { create(:access_token, resource_owner_id: author.id) }
        let(:params) { { access_token: access_token.token } }
        let(:delete_answer) { delete api_path, params: params, headers: headers }

        it_behaves_like 'API Successfulable' do
          before { delete_answer }
        end

        it 'delete answer from DB' do
          expect{ delete_answer }.to change(Answer, :count).by(-1)
        end

        it 'return empty json' do
          delete_answer
          expect(json).to be_empty
        end
      end

      context 'non author/admin' do
        let(:access_token) { create(:access_token) }
        let(:params) { { access_token: access_token.token } }

        before { delete api_path, params: params, headers: headers }

        it 'cannot delete the answer' do
          expect { answer.reload }.to_not change(Answer, :count)
        end

        it_behaves_like 'API Unprocessable'
      end
    end
  end

end
