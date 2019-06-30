class Answer < ApplicationRecord
  belongs_to :question
  
  validates :correct, :body, presence: true
end
