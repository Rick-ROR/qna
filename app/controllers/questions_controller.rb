class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  expose :questions, ->{ Question.all }
  expose :question, -> { params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new }

  def create
    @question = current_user.author_questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      redirect_to @question, notice: 'You have no rights to do this.'
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question was successfully deleted.'
    else
      redirect_to question, notice: 'You have no rights to do this.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

end
