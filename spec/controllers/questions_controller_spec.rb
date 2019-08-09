require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  before { login(user) }

  describe 'GET #new' do
    it 'assigns to new questions new link' do
      get :new
      expect(assigns(:exposed_question).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      let(:post_question) { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question to DB' do
        expect { post_question }.to change(Question, :count).by(1)
      end

      it 'saves a new question to the logged user' do
        expect { post_question }.to change(user.author_questions, :count).by(1)
      end

      it 'redirects to show view' do
        expect(post_question).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:post_question) { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do
        expect { post_question }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        expect(post_question).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    context 'by author' do
      let(:question) { create(:question, author: user) }

      context 'with valid attributes' do
        before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render update question' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:update_invalid)  { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question' do
          expect do
            update_invalid
            question.reload
          end.to not_change(question, :title).and not_change(question, :body)
        end

        it 're-renders update view' do
          expect(update_invalid ).to redirect_to question
        end
      end
    end

    context 'by other user' do
      let(:question) { create(:question) }
      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js } }

      it 'does not change answer attrs' do
        expect { question.reload }.to not_change(question, :title).and not_change(question, :body)
      end

      it 'redirects to question' do
        expect(response).to redirect_to question
      end

      it 'flashes message with error' do
        expect(flash[:notice]).to eq 'You have no rights to do this.'
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

