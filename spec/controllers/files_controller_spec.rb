require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    before { login(user) }

    context 'by author' do
      let(:question) { create(:question, :with_file, author: user) }
      let(:del_file) { delete :destroy, params: { id: question.files.first }, format: :js }

      it 'file deletion' do
        expect { del_file }.to change(question.files,	:count).by(-1)
      end

      it 'render template update' do
        expect(del_file).to render_template 'questions/update.js.erb'
      end

    end

    context 'by other user' do
      let(:question) { create(:question, :with_file, author: create(:user)) }
      let(:del_file) { delete :destroy, params: { id: question.files.first }, format: :js }

      it 'trying to delete a file' do
        expect { del_file }.to_not change(question.files, :count)
      end

      it 'redirects to question' do
        expect(del_file).to redirect_to question
      end

      it 'flashes message with error' do
        del_file
        expect(flash[:alert]).to eq 'You have no rights to do this.'
      end
    end
  end

end
