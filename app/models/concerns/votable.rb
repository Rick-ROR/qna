module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def rating
      votes.sum(:state)
    end
  end
end
