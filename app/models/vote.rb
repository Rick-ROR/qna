class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :state, inclusion: { in: [true, false] }
  validates :author_id, uniqueness: { scope: [:votable_type, :votable_id], case_sensitive: false }

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
