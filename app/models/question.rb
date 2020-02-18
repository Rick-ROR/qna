class Question < ApplicationRecord
  include Authorable
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :subscribe

  private

  def subscribe
    subscriptions.create(user: author)
  end
end
