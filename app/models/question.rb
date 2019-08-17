class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :author, class_name: 'User'
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
