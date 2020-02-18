# Preview all emails at http://localhost:3000/rails/mailers/subscription
class SubscriptionPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/subscription/notification
  def notification
    answer = Answer.all.sample
    subscriber = User.all.sample
    SubscriptionMailer.notification(subscriber, answer)
  end

end
