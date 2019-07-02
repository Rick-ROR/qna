require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) {create(:answer)}

    # it 'assigns the requested answer to @answer' do
    #   get :show, params: {id: answer}
    #   expect(assigns(:answer)).to eq answer
    # end

    it 'renders show view' do
      get :show, params: {id: answer}
      expect(response).to render_template :show
    end

  end

end
