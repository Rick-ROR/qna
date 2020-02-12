require 'rails_helper'

describe 'Questions API DELETE', type: :request do

  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'questions author / admin' do
        let(:access_token) { create(:access_token, resource_owner_id: author.id) }
        let(:params) { { access_token: access_token.token } }
        let(:delete_question) { delete api_path, params: params, headers: headers }

        it_behaves_like 'API Successfulable' do
          before { delete_question }
        end

        it 'delete question from DB' do
          expect{ delete_question }.to change(Question, :count).by(-1)
        end

        it 'return empty json' do
          delete_question
          expect(json).to be_empty
        end
      end

      context 'non author/admin' do
        let(:access_token) { create(:access_token) }
        let(:params) { { access_token: access_token.token } }

        before { delete api_path, params: params, headers: headers }

        it 'cannot delete the question' do
          expect { question.reload }.to_not change(Question, :count)
        end

        it_behaves_like 'API Unprocessable'
      end
    end

  end

end
