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
    let(:del_answer) { delete :destroy, params: { id: answer }, format: :js }

    context 'by author' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'deletes the question' do
        expect { del_answer }.to change(Answer,	:count).by(-1)
      end

      it 'redirects to question show' do
        expect(del_answer).to render_template(:destroy)
      end
    end

    context 'by another author' do
      let!(:answer) { create(:answer, question: question) }

      it 'trying to delete a question' do
        expect { del_answer }.to_not change(Answer, :count)
      end

      it 'redirects to root' do
        expect(del_answer).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do

    context 'by author' do
      let!(:answer) { create(:answer, question: question, author: user) }

      context 'with valid attrs' do
        before  { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

        it 'changes answer attrs' do
          expect(answer.reload.body).to eq 'new body'
        end

        it 'render update view' do
          expect(response).to render_template(:update)
        end
      end

      context 'with invalid attrs'
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not change answer attrs' do
        expect { answer.reload }.to_not change(answer, :body)
      end

      it 'render update view' do
        expect(response).to render_template(:update)
      end
    end

    context 'by other user' do
      let!(:answer) { create(:answer, question: question) }
      before { patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js }

      it 'does not change answer attrs' do
        expect { answer.reload }.to_not change(answer, :body)
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end

      it 'flashes message with error ' do
        expect(flash[:alert]).to eq 'You are not authorized to access this page.'
      end
    end

  end

  describe 'PATCH #best' do
    let(:answer) { create(:answer, question: question) }
    before { patch :best, params: { id: answer }, format: :js }

    context 'by author question' do
      let(:question) { create(:question, author: user) }

      it 'make best answer' do
        expect(answer.reload.best).to eq true
      end

      it 'render template best' do
        expect(response).to render_template(:best)
      end
    end

    context 'by another author' do
      it 'trying to make best answer' do
        expect { answer.reload }.to_not change(answer, :best)
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end

  end
end
