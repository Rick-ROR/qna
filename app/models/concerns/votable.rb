module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def by_user(user)
      votes.where(author: user)
    end

    def rating
      votes.sum(:state)
    end

    def vote_path
      "vote_#{self.class.name.singularize.underscore}_path"
    end
  end
end
