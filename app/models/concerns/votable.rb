module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def by_user(user)
      votes.where(author: user)
    end

    def rating
      scores = self.votes.select(:state).group(:state).count
      scores.default = 0
      scores[true] - scores[false]
    end

    def vote_path
      "vote_#{self.class.name.singularize.underscore}_path"
    end
  end
end
