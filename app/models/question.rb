class Question < ApplicationRecord
  include Linkable
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
