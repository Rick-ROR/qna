class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action -> { question.links.build }, only: [:new, :create]

  expose :questions, ->{ Question.all.order(created_at: :desc) }
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
      redirect_to @question, alert: 'You have no rights to do this.'
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question was successfully deleted.'
    else
      redirect_to question, alert: 'You have no rights to do this.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     :vote,
                                     Voted::STRONG_PARAMS,
                                     files: [],
                                     links_attributes: [:name, :url, :id, :_destroy],
                                     reward_attributes: [:title, :image],
                                     )
  end

end
