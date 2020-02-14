# Preview all emails at http://localhost:3000/rails/mailers/daily_digest
class DailyDigestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/daily_digest/digest
  def digest
    questions = Question.all.sample(5).collect{ |question| question.slice(:id, :title) }
    DailyDigestMailer.digest(User.all.sample, questions)
  end

end
