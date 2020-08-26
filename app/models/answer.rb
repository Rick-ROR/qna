class Answer < ApplicationRecord
  include Authorable
  include Linkable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  has_one :reward

  validates :body, presence: true

  has_many_attached :files

  default_scope { order(best:  :desc, created_at: :desc) }
  scope :get_best, -> { where(best: true) }

  after_create_commit :send_notice

  def make_best
    transaction do
      question.answers.get_best.take&.update!(best: false)
      update!(best: true)
      update!(reward: question.reward) if question.reward
    end
  end

  private

  def send_notice
    NotifyNewAnswerJob.perform_later(self)
  end

end
