require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  allow_scopes = Services::SearchSphinx::ALLOW_SCOPES

  describe 'GET #result' do
    let!(:questions) { create_list(:question, 2) }
    let!(:service) { Services::SearchSphinx.new }

    context "with allow scopes" do
      allow_scopes.keys.each do |scope|
        before do
          allow(Services::SearchSphinx).to receive(:new).and_return(service)
          expect(service).to receive(:call).and_return(questions)
          get :result, params: { scope: scope, query: "title" }
        end

        it "successful calls with scope #{scope} => #{allow_scopes[scope]}" do
          expect(response).to be_successful
        end

        it "renders result view" do
          expect(response).to render_template :result
        end

        it "assign @results" do
          expect(assigns(:results)).to eq questions
        end

      end
    end

    context "with not allow scope" do
      before do
        allow(Services::SearchSphinx).to receive(:new).and_return(service)
        expect(service).to receive(:call).and_return(questions)
        get :result, params: { scope: "Lory", query: "" }
      end

      it "successful for default scope ThinkingSphinx" do
        expect(response).to be_successful
      end

      it "renders result view" do
        expect(response).to render_template :result
      end

      it "assign @results" do
        expect(assigns(:results)).to eq questions
      end
    end
  end
end
