class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  has_one_attached :file

  validates :title, :body, presence: true
end
