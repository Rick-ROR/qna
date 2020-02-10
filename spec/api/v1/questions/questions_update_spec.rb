require 'rails_helper'

describe 'Questions API UPDATE', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'PATCH /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:api_path) {  "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: author.id) }

      context 'with valid attributes' do
        let(:new_attrs) { attributes_for(:question) }

        let(:valid_params) do
          { access_token: access_token.token,
            id: question,
            question: new_attrs
          }
        end

        before { patch api_path, params: valid_params, headers: headers }
        let(:question_response) { json['question'] }

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'changes question attrs' do
          question.reload

          new_attrs.each do |attr, value|
            expect(question[attr.to_s]).to eq value
          end
        end

        it 'returns an updated question' do
          question.reload

          question.attributes.each do |attr, value|
            expect(question_response[attr.to_s]).to eq value.as_json
          end
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) do
          { access_token: access_token.token,
            id: question,
            question: attributes_for(:question, :invalid)
          }
        end
        before { patch api_path, params: invalid_params, headers: headers }

        it 'does not change question' do
          expect { question.reload }.to not_change(question, :title).and not_change(question, :body)
        end


        it 'returns 422 status with errors' do
          expect(response.status).to eq 422
          expect(json.keys).to eq %w[ errors ]
        end
      end

      context 'with valid attributes by non-author question' do
        let(:access_token) { create(:access_token) }

        let(:params) do
          { access_token: access_token.token,
            id: question,
            question: attributes_for(:question)
          }
        end
        before { patch api_path, params: params, headers: headers }

        it 'does not change question' do
          expect { question.reload }.to not_change(question, :title).and not_change(question, :body)
        end


        it 'returns 422 status with errors' do
          expect(response.status).to eq 422
          expect(json.keys).to eq %w[ errors ]
        end
      end
    end
  end

end
