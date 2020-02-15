require 'rails_helper'

RSpec.describe Services::Subscription, type: :services do
  let!(:answer) { create(:answer) }

  context 'for subscribers' do
    let(:subscriptions) { create_list(:subscription, 3, question: answer.question) }

    it 'sends a notification about a new question to all subscribers' do
      # get all subscriptions include author of question
      all_subs = answer.question.subscriptions
      all_subs.each {|subscription| expect(SubscriptionMailer).to receive(:notification)
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

       # не вызываем тк вызов идёт при создании ответа
       # subject.send_notification(answer)
    end
  end

end
