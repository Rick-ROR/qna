require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do

    let(:api_path) {  '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].last }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        attrs = %w[id title body created_at updated_at]

        attrs.each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :full_pack, count_relations: 3) }
    let(:api_path) {  "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        attrs = %w[id title body created_at updated_at]

        attrs.each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'links' do
        let(:link) { question.links.first }
        let(:link_response) { question_response['links'].last }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 3
        end

        it 'returns all public fields' do
          attrs = %w[name url]

          attrs.each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'].last }

        it 'returns urls of files' do
          expect(question_response['files'].size).to eq 1
        end

        it 'returns url file' do
          expect(file_response).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'comments' do
        let(:comment) { question.comments.first }
        let(:comment_response) { question_response['comments'].last }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          attrs = %w[id body created_at updated_at]

          attrs.each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].last }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          attrs = %w[id body author_id created_at updated_at]

          attrs.each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

    end
  end

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

        it 'saves a new question to DB' do
          expect { post_question }.to change(Question, :count).by(1)
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
            expect(question_response[attr.to_s]).to eq value
          end
        end

        it 'return a update question' do
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

  describe 'PATCH /api/v1/questions/:id' do
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

        it 'returns 200 status' do
          delete_question
          expect(response).to be_successful
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

