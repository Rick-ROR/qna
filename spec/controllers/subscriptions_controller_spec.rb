require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }
  before { login(user) }

  describe 'POST #subscribe' do
    let(:subscribe) { patch :subscribe, params: { question_id: question.id, format: :js } }

    context 'user subscribe' do

      it 'saves a new subscription to DB' do
        expect { subscribe }.to change(Subscription, :count).by(1)
      end

      it 'saves a new subscription to the logged user' do
        expect { subscribe }.to change(user.subscriptions, :count).by(1)
      end

      it_behaves_like 'API Successfulable' do
        before { subscribe }
      end

    end

    context 'user unsubscribe' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it 'delete subscription from DB' do
        expect { subscribe }.to change(Subscription, :count).by(-1)
      end

      it_behaves_like 'API Successfulable' do
        before { subscribe }
      end

    end

  end

end
