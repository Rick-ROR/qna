class Services::DailyDigest
  def send_digest
    questions = Question.where(created_at: Date.yesterday.all_day)

    return if questions.empty?

    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
