require 'rails_helper'

describe 'Questions API CREATE', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'POST /api/v1/questions' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:api_path) {  "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        let(:question) { attributes_for(:question) }
        let(:link) { attributes_for(:link) }

        let(:valid_params) do
          { access_token: access_token.token,
            question: question.merge(links_attributes: { '0' => link})
          }
        end
        let(:post_question) { post api_path, params: valid_params, headers: headers }
        let(:question_response) { json['question'] }

        it 'returns 200 status' do
          post_question
          expect(response).to be_successful
        end

        it 'saves a new question to the user token' do
          expect { post_question }.to change(user.author_questions, :count).by(1)
        end

        it 'return a new question with the given fields' do
          post_question

          question.each do |attr, value|
            expect(question_response[attr.to_s]).to eq value
          end

          link.each do |attr, value|
            expect(question_response["links"].first[attr.to_s]).to eq value
          end
        end
      end


      context 'with invalid attributes' do
        let(:invalid_params) do
          { access_token: access_token.token,
            question: attributes_for(:question, :invalid)
          }
        end
        let(:post_question) { post api_path, params: invalid_params, headers: headers }

        it 'does not save the question' do
          expect { post_question }.to_not change(Question, :count)
        end

        it 'returns 422 status with errors' do
          post_question

          expect(response.status).to eq 422
          expect(json.keys).to eq %w[ errors ]
        end
      end
    end

  end

end
