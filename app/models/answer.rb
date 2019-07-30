class Answer < ApplicationRecord
  belongs_to :question, class_name: 'Question'
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  default_scope { order(best:  :desc, created_at: :desc) }
  scope :get_best, -> { where(best: true) }


  def make_best
    transaction do
      question.answers.get_best&.update(best: false)
      update(best: true)
    end
  end

end
