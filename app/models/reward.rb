class Reward < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :title, presence: true
  validate :attached_type

  private

  def attached_type
    types = ['jpeg', 'png', 'gif']

    if image.attached?
      errors.add(:image, ": Available file types for reward: #{types.join(', ')}") unless image.content_type =~ /^image\/(#{types.join('|')})/
    end

  end
end
