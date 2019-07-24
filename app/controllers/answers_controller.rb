class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose :answers, ->{ Answer.all }
  expose :answer
  expose :question

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to question, notice: 'Reply successfully sent.'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer was successfully deleted.'
    else
      redirect_to answer.question, notice: 'You have no rights to do this.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end

end
