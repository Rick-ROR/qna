require 'rails_helper'

describe 'Answers API CREATE', type: :request do

  describe 'POST /api/v1/questions/:id/answers' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:question) { create(:question) }
    let(:api_path) {  "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        let(:answer) { attributes_for(:answer) }
        let(:link) { attributes_for(:link) }

        let(:valid_params) do
          { access_token: access_token.token,
            question_id: question.id,
            answer: answer.merge(links_attributes: { '0' => link})
          }
        end
        let(:post_answer) { post api_path, params: valid_params, headers: headers }
        let(:answer_response) { json['answer'] }

        it_behaves_like 'API Successfulable' do
          before { post_answer }
        end

        it 'saves a new answer to the user token' do
          expect { post_answer }.to change(user.author_answers, :count).by(1)
        end

        it 'return a new answer with the given fields' do
          post_answer

          answer.each do |attr, value|
            expect(answer_response[attr.to_s]).to eq value
          end

          link.each do |attr, value|
            expect(answer_response["links"].first[attr.to_s]).to eq value
          end
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) do
          { access_token: access_token.token,
            answer: attributes_for(:answer, :invalid)
          }
        end
        let(:post_answer) { post api_path, params: invalid_params, headers: headers }

        it 'does not save the answer' do
          expect { post_answer }.to_not change(Answer, :count)
        end

        it_behaves_like 'API Unprocessable' do
          before { post_answer }
        end
      end
    end

  end

end
