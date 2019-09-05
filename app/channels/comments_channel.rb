class CommentsChannel < ApplicationCable::Channel
  def follow
    question = Question.find(params[:id])
    stream_from "comments:#{question.id}"
  end
end
