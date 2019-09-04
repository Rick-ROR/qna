class AnswersChannel < ApplicationCable::Channel
  def follow
    question = Question.find(params[:id])
    stream_from "answers:#{question.id}"
  end
end
