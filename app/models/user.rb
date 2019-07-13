class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :author_questions, foreign_key: 'author_id', class_name: 'Question'

  def author_of?(resource)
    id == resource.author_id
  end
end
