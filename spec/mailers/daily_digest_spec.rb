require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 2, created_at: Date.yesterday)}
    let!(:mail) { DailyDigestMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("This is a digest")
    end

    it "body has questions" do
      domain = "http://#{default_url_options[:host]}:#{default_url_options[:port]}"
      questions.each do |question|
        expect(mail.body.encoded).to have_link(question.title, href: "#{domain}/questions/#{question.id}")
      end
    end
  end


end
