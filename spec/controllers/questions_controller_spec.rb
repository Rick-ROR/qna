require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  before { login(user) }

  describe 'POST #create' do

    context 'with valid attributes' do

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'saves a new question to the logged user' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.author_questions, :count).by(1)
      end

    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

  end

  describe 'PATCH #update' do

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:exposed_question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'} }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:question_dup) { question.dup }
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq question_dup.title
        expect(question.body).to eq question_dup.body
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:del_question) { delete :destroy, params: { id: question } }

    context 'by author' do
      let!(:question) { create(:question, author: user) }

      it 'deletes the question' do
        expect { del_question }.to change(Question,	:count).by(-1)
      end

      it 'redirects to index' do
        expect(del_question).to redirect_to questions_path
      end
    end

    context 'by another author' do
      let!(:question) { create(:question, author: create(:user)) }

      it 'trying to delete a question' do
        expect { del_question }.to_not change(Question, :count)
      end

      it 'redirects to show' do
        expect( del_question ).to redirect_to question
      end
    end
  end
end

