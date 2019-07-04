class AnswersController < ApplicationController

  expose :answers, ->{ Answer.all }
  expose :answer
  expose :question

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end

end
