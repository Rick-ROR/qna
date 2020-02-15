class NotifyNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::Subscription.new.send_notification(answer)
  end
end
