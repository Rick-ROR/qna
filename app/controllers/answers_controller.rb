class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose :answers, ->{ Answer.all }
  expose :answer
  expose :question

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to question, notice: 'Reply successfully sent.'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end

end
