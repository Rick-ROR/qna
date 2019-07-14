class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  # validates :body, :correct, presence: true
  validates :correct, inclusion: { in: [true, false] }
  validates :body, presence: true
end
