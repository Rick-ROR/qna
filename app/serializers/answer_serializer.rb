class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :best, :created_at, :updated_at, :author_id, :question_id
  has_many :links
  has_many :files
  has_many :comments

  def files
    object.files.map do |file|
      rails_blob_path(file, only_path: true)
    end
  end
end
