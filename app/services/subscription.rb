class Services::Subscription
  def send_notification(answer)
    answer.question.subscriptions.includes(:user).find_each do |subscription|
      SubscriptionMailer.notification(subscription.user, answer).deliver_later
    end
  end
end
