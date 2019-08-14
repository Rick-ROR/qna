class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  validates :title, presence: true

  has_one_attached :image
end
