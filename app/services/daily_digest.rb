class Services::DailyDigest
  def send_digest
    questions = Question.where('created_at > ?', 24.hours.ago).select(:id, :title)

    if questions.any?
      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.digest(user, questions.as_json).deliver_later
      end
    end
  end
end
