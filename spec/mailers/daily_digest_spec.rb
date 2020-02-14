require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:questions) { create_list(:question, 2) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("This is a digest")
    end
  end


end
