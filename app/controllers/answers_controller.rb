class AnswersController < ApplicationController

  def show
  end

  def new
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  # def answer_params
  #   params.require(:answer).permit(:title, :body)
  # end
end
