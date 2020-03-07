class NotifyNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::MailingNotifications.new.send_notification(answer)
  end
end
