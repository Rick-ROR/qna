require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "notification" do
    let(:answer) { build(:answer) }
    let(:subscriber) { build(:user) }
    let(:mail) { SubscriptionMailer.notification(subscriber, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notification")
      expect(mail.to).to eq [subscriber.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end

end
