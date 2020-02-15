class SubscriptionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.notification.subject
  #
  def notification(subscriber, answer)
    @answer = answer
    @subscriber = subscriber

    mail to: subscriber.email
  end
end
