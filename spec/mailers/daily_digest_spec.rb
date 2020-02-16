require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 2, created_at: Date.yesterday) }
    let!(:old_question) { create(:question, created_at: Date.today.days_ago(2)) }
    let!(:mail) { DailyDigestMailer.digest(user) }
    let!(:domain) { "http://#{default_url_options[:host]}:#{default_url_options[:port]}" }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("This is a digest")
    end

    it "body has questions" do
      questions.each do |question|
        expect(mail.body.encoded).to have_link(question.title, href: "#{domain}/questions/#{question.id}")
      end
    end

    it "body not has old questions" do
      expect(mail.body.encoded).to_not have_link(old_question.title, href: url_for(old_question))
    end
  end
  
end
