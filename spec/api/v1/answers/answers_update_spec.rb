require 'rails_helper'

describe 'Answers API UPDATE', type: :request do

  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:author) { create(:user) }
    let(:answer) { create(:answer, author: author) }
    let(:api_path) {  "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      context 'with valid attributes' do
        let(:new_attrs) { attributes_for(:answer) }

        let(:valid_params) do
          { access_token: access_token.token,
            id: answer,
            answer: new_attrs
          }
        end

        before { patch api_path, params: valid_params, headers: headers }
        let(:answer_response) { json['answer'] }

        it_behaves_like 'API Successfulable'

        it 'the answer has been updated' do
          answer.reload

          new_attrs.each do |attr, value|
            expect(answer[attr.to_s]).to eq value
          end
        end

        it_behaves_like 'API return Pub Fields' do
          let(:fields) { %w[id body best author_id created_at updated_at] }
          let(:resource) { answer.reload }
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) do
          { access_token: access_token.token,
            id: answer,
            answer: attributes_for(:answer, :invalid)
          }
        end
        before { patch api_path, params: invalid_params, headers: headers }

        it 'does not change answer' do
          expect { answer.reload }.to not_change(answer, :body)
        end

        it_behaves_like 'API Unprocessable'
      end

      context 'with valid attributes by non-author answer' do
        let(:access_token) { create(:access_token) }

        let(:params) do
          { access_token: access_token.token,
            id: answer,
            answer: attributes_for(:answer)
          }
        end
        before { patch api_path, params: params, headers: headers }

        it 'does not change answer' do
          expect { answer.reload }.to not_change(answer, :body)
        end

        it_behaves_like 'API Unprocessable'
      end
    end

  end

end
