require 'rails_helper'

RSpec.describe Services::DailyDigest, type: :services do
  let!(:users) { create_list(:user, 2) }

  it 'sends daily digest to all users' do
    create_list(:question, 2, created_at: Date.yesterday, author: users.first)

    users.each {|user| expect(DailyDigestMailer).to receive(:digest)
                                                      .with(user)
                                                      .and_call_original}
    subject.send_digest
  end

  it 'not call Mailer if no new yesterday\'s questions' do

    expect(DailyDigestMailer).to_not receive(:digest)

    subject.send_digest
  end

end
