require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do

    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, comment: attributes_for(:comment), author: user }, format: :js }

      it 'saves a new comment to given question to DB' do
        expect { action }.to change(question.comments, :count).by(1)
      end

      it 'saves a new comment to the logged user' do
        expect { action }.to change(user.author_comments, :count).by(1)
      end

      it 'render template :create for comment' do
        expect(action).to render_template(:create)
      end

    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid), author: user }, format: :js }

      it 'does not save comment' do
        expect { action }.not_to change(Comment, :count)
      end

      it 're-renders template :create for comment' do
        expect(action).to render_template(:create)
      end
    end
  end

end
