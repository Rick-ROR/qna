require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '0952' }, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns empty body' do
        get '/api/v1/questions', params: { access_token: '0952' }, headers: headers
        expect(response.body).to be_empty
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json.first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        # byebug
        expect(json.size).to eq 2
      end

      it 'returns all public fields' do
        attrs = %w[id title body created_at updated_at]

        attrs.each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
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
          # byebug

          attrs.each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

    end
  end
end

