require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) {create(:answer)}

    it 'renders show view' do
      get :show, params: {id: answer}
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do

    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves a new answer to the given question to database' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        expect(action).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes'
  end

end
