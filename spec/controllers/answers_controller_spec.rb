require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do

    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves a new answer to the given question to DB' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer to the logged user' do
        expect { action }.to change(user.author_answers, :count).by(1)
      end

      it 'redirects to question show' do
        expect(action).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not save answer' do
        expect { action }.not_to change(Answer, :count)
      end

      it 're-renders new view on question show' do
        expect(action).to render_template(:create)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:del_answer) { delete :destroy, params: { id: answer } }

    context 'by author' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'deletes the question' do
        expect { del_answer }.to change(Answer,	:count).by(-1)
      end

      it 'redirects to question show' do
        expect(del_answer).to redirect_to question
      end
    end

    context 'by another author' do
      let!(:answer) { create(:answer, question: question) }

      it 'trying to delete a question' do
        expect { del_answer }.to_not change(Answer, :count)
      end

      it 'redirects to question show' do
        expect(del_answer).to redirect_to question
      end
    end
  end
end
