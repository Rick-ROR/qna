require 'rails_helper'

describe 'Answers API DELETE', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

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

        it 'returns 200 status' do
          delete_answer
          expect(response).to be_successful
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

        it 'returns 422 status with errors' do
          expect(response.status).to eq 422
          expect(json.keys).to eq %w[ errors ]
        end
      end
    end
  end

end
