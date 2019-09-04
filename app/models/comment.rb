class Comment < ApplicationRecord
  include Authorable

  belongs_to :commentable, polymorphic: true
end
