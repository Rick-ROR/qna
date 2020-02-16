require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }
  before { login(user) }

  describe 'POST #create' do

    context 'user trying to subscribe' do
      context 'with valid attributes' do
        let(:subscribe) { post :create, params: { question_id: question.id, format: :js } }

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

      context 'with invalid attributes' do
        let(:subscribe) { post :create, params: { format: :js } }

        it 'does not save the subscription to DB' do
          expect { subscribe }.to_not change(Subscription, :count)
        end

        it 'returns response 422-error' do
          subscribe
          expect(response.status).to eq 422
        end
      end
    end

    context 'guest trying to subscribe' do
      before { sign_out :user }
      let(:subscribe) { post :create, params: { question_id: question.id, format: :js } }

      it 'does not save the subscription to DB' do
        expect { subscribe }.to_not change(Subscription, :count)
      end

      it 'returns 401 status' do
        subscribe
        expect(response.status).to eq 401
      end
    end

  end

  describe 'DELETE #destroy' do
    context 'subscription owner is trying to unsubscribe' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      context 'with valid attributes' do
        let(:unsubscribe) { delete :destroy, params: { question_id: question.id, format: :js } }

        it 'delete subscription from DB' do
          expect { unsubscribe }.to change(Subscription, :count).by(-1)
        end

        it_behaves_like 'API Successfulable' do
          before { unsubscribe }
        end
      end

      context 'with invalid attributes' do
        let(:unsubscribe) { delete :destroy, params: { format: :js } }

        it 'does not delete subscription from DB' do
          expect { unsubscribe }.to_not change(Subscription, :count)
        end

        it 'returns response 422-error' do
          unsubscribe
          expect(response.status).to eq 422
        end
      end
    end

    context 'guest trying to unsubscribe' do
      before { sign_out :user }
      let(:unsubscribe) { delete :destroy, params: { question_id: question.id, format: :js } }

      it 'does not save the subscription to DB' do
        expect { unsubscribe }.to_not change(Subscription, :count)
      end

      it 'returns 401 status' do
        unsubscribe
        expect(response.status).to eq 401
      end
    end

  end

end
