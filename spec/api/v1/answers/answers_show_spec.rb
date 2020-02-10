require 'rails_helper'

describe 'Answers API SHOW', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

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

end
