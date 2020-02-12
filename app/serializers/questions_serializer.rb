class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :author_id, :short_title

  def short_title
    object.title.truncate(7)
  end
end
