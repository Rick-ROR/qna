class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :author_questions, foreign_key: 'author_id', class_name: 'Question'
  has_many :author_comments, foreign_key: 'author_id', class_name: 'Comment'
  has_many :author_answers, foreign_key: 'author_id', class_name: 'Answer'
  has_many :author_votes, foreign_key: 'author_id', class_name: 'Vote'
  has_many :rewards, through: :author_answers

  def author_of?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)

  end
end
