require 'rails_helper'

RSpec.describe NotifyNewAnswerJob, type: :job do
  let(:service) { double('Services::MailingNotifications') }
  # нужен let! или build иначе дважды вызов Services::MailingNotifications в тесте
  let(:answer) { build(:answer) }

  before do
    allow(Services::MailingNotifications).to receive(:new).and_return(service)
  end

  it 'calls Services::MailingNotifications#send_notification' do
    expect(service).to receive(:send_notification)
    NotifyNewAnswerJob.perform_now(answer)
  end
end
