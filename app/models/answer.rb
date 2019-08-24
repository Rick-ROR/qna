class Answer < ApplicationRecord
  include Linkable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_one :reward

  validates :body, presence: true

  has_many_attached :files

  default_scope { order(best:  :desc, created_at: :desc) }
  scope :get_best, -> { where(best: true) }


  def make_best
    transaction do
      question.answers.get_best.take&.update!(best: false)
      update!(best: true)
      update!(reward: question.reward) if question.reward
    end
  end

end
