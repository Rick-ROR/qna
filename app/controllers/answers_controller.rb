class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  expose :answers, ->{ Answer.all }
  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }
  expose :question

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @question = answer.question
    if current_user.author_of?(answer)
      answer.update(answer_params)
    else
      redirect_to @question, notice: 'You have no rights to do this.'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    else
      redirect_to answer.question, notice: 'You have no rights to do this.'
    end
  end

  def best
    if current_user.author_of?(answer.question)
      answer.make_best
    else
      redirect_to answer.question, notice: 'You have no rights to do this.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :id, :_destroy])
  end

end
