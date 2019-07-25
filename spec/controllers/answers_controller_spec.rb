require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do

    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }

      it 'saves a new answer to the given question to DB' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer to the logged user' do
        expect { action }.to change(user.author_answers, :count).by(1)
      end

      it 're-renders template :create for answer' do
        expect(action).to render_template(:create)
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not save answer' do
        expect { action }.not_to change(Answer, :count)
      end

      it 're-renders template :create for answer' do
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

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'with valid attrs' do
      let!(:update_answer) { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it 'changes answer attrs' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update view' do
        expect(response).to render_template(:update)
      end
    end

    context 'with invalid attrs'
      let(:update_answer) { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not change answer attrs' do
        expect { update_answer }.to_not change(answer, :body)
      end

      it 'render update view' do
        update_answer
        expect(response).to render_template(:update)
      end

  end
end
