class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose :answers, ->{ Answer.all }
  expose :answer
  expose :question

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    else
      redirect_to answer.question, notice: 'You have no rights to do this.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best)
  end

end
