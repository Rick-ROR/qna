class ApplicationMailer < ActionMailer::Base
  if Rails.env.production?
    default from: Rails.application.credentials[Rails.env.to_sym][:mailer][:user]
  else
    default from: 'qna_dev@example.com'
  end

  layout 'mailer'
end
