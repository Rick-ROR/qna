class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable, :recoverable,
         :rememberable, :validatable,
         :confirmable, :omniauthable,
          omniauth_providers: %i[github vkontakte]

  has_many :author_questions, foreign_key: 'author_id', class_name: 'Question'
  has_many :author_comments, foreign_key: 'author_id', class_name: 'Comment'
  has_many :author_answers, foreign_key: 'author_id', class_name: 'Answer'
  has_many :author_votes, foreign_key: 'author_id', class_name: 'Vote'
  has_many :rewards, through: :author_answers
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  def author_of?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.call(auth)
  end

  def email_format_valid?
    valid?
    errors[:email].delete("has already been taken")
    errors[:email].blank?
  end

  def get_sub_on_question(question)
    subscriptions.find_by(question_id: question)
  end
end
