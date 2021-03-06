require 'rails_helper'

describe 'Questions API INDEX', type: :request do
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

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Successfulable'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it_behaves_like 'API return Pub Fields' do
        let(:fields) { %w[id title body author_id created_at updated_at] }
        let(:resource) { question }
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

    end
  end

end
