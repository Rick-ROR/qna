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

end
