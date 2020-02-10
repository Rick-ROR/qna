require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do

    let(:question) { create(:question) }
    let(:api_path) {  "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answers_response) { json['answers'].last }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        attrs = %w[id body best author_id created_at updated_at]

        attrs.each do |attr|
          expect(answers_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :full_pack, count_relations: 3) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        attrs = %w[id body best author_id created_at updated_at]

        attrs.each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'links' do
        let(:link) { answer.links.first }
        let(:link_response) { answer_response['links'].last }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 3
        end

        it 'returns all public fields' do
          attrs = %w[name url]

          attrs.each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_response) { answer_response['files'].last }

        it 'returns urls of files' do
          expect(answer_response['files'].size).to eq 1
        end

        it 'returns url file' do
          expect(file_response).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'comments' do
        let(:comment) { answer.comments.first }
        let(:comment_response) { answer_response['comments'].last }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          attrs = %w[id body created_at updated_at]

          attrs.each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

    end
  end

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

        it 'saves a new answer to DB' do
          expect { post_answer }.to change(Answer, :count).by(1)
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

        it 'returns 422 status with errors' do
          post_answer

          expect(response.status).to eq 422
          expect(json.keys).to eq %w[ errors ]
        end
      end
    end

  end

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

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'changes answer attrs' do
          answer.reload

          new_attrs.each do |attr, value|
            expect(answer[attr.to_s]).to eq value
          end
        end

        it 'returns an updated answer' do
          answer.reload

          answer.attributes.each do |attr, value|
            expect(answer_response[attr.to_s]).to eq value.as_json
          end
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

        it 'returns 422 status with errors' do
          expect(response.status).to eq 422
          expect(json.keys).to eq %w[ errors ]
        end
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

        it 'returns 422 status with errors' do
          expect(response.status).to eq 422
          expect(json.keys).to eq %w[ errors ]
        end
      end
    end

  end


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

