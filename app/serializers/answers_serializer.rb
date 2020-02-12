class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :created_at, :updated_at, :author_id
end
