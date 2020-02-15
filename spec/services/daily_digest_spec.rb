require 'rails_helper'

RSpec.describe Services::DailyDigest, type: :services do
  let(:questions) {create_list(:question, 3)}
  let!(:users) { questions.map{ |q| q.author } }

  it 'sends daily digest to all users' do
    questions_slice = questions.collect{ |question| question.slice(:id, :title) }

    users.each {|user| expect(DailyDigestMailer).to receive(:digest)
                                                      .with(user, questions_slice)
                                                      .and_call_original}
    subject.send_digest
  end

end
