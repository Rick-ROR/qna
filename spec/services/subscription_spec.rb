require 'rails_helper'

RSpec.describe Services::Subscription, type: :services do
  let(:answer) { create(:answer) }

  context 'for subscribers' do
    let(:subscriptions) { create_list(:subscription, 3, question: answer.question) }

    it 'sends a notification about a new question to all subscribers' do
      subscriptions.each {|subscription| expect(SubscriptionMailer).to receive(:notification)
                                                                         .with(subscription.user, answer)
                                                                         .and_call_original}
      subject.send_notification(answer)
    end
  end


  context 'for not subscribers' do
    let(:users) {create_list(:user, 2)}

    it 'doesn\'t sends a notification about a new question' do
      users.each {|user| expect(SubscriptionMailer).to_not receive(:notification)
                                                                         .with(user, answer)
                                                                         .and_call_original}
      subject.send_notification(answer)
    end
  end

end
