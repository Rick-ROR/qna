class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :author, class_name: 'User'

  validates :state, inclusion: { in: [true, false] }
  validates :author_id, uniqueness: { scope: [:votable_type, :votable_id], case_sensitive: false }

  scope :truly, -> { where(state: true) }
  scope :falsely, -> { where(state: false) }

  def voting(state)
    state = ActiveRecord::Type::Boolean.new.cast(state)

    if twice?(state)
      self.destroy!
    else
      self.state = state
      self.save!
    end
  end

  def twice?(state)
    self.state == state
  end
end
