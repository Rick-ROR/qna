require 'rails_helper'

describe 'Answers API INDEX', type: :request do
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
      let(:answer_response) { json['answers'].last }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it_behaves_like 'API return Pub Fields' do
        let(:fields) { %w[id body best author_id created_at updated_at] }
        let(:resource) { answer }
      end
    end
  end

end
