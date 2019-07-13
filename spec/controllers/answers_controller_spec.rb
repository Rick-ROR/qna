require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves a new answer to the given question to DB' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show' do
        expect(action).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save answer' do
        expect { action }.not_to change(Answer, :count)
      end

      it 're-renders new view on question show' do
        expect(action).to render_template('questions/show')
      end
    end
  end

end
