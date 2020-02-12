require 'rails_helper'

describe 'Questions API SHOW', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :full_pack, count_relations: 2) }
    let(:api_path) {  "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it_behaves_like 'API return Pub Fields' do
        let(:fields) { %w[id title body author_id created_at updated_at] }
        let(:resource) { question }
      end

      describe 'links' do
        let(:link) { question.links.first }
        let(:link_response) { question_response['links'].last }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 2
        end

        it_behaves_like 'API return Pub Fields' do
          let(:fields) { %w[name url] }
          let(:resource) { link }
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
          expect(question_response['comments'].size).to eq 2
        end

        it_behaves_like 'API return Pub Fields' do
          let(:fields) { %w[id body created_at updated_at] }
          let(:resource) { comment }
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].last }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 2
        end

        it_behaves_like 'API return Pub Fields' do
          let(:fields) { %w[id body best author_id created_at updated_at] }
          let(:resource) { answer }
        end
      end

    end
  end

end
