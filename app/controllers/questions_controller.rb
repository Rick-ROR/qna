class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action -> { question.links.build }, only: [:new, :create]

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

  def render_json(item)
    body = { "id": item.id, "score": item.score }
    render json: Hash[param_name(item), body]
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     :vote,
                                     files: [],
                                     links_attributes: [:name, :url, :id, :_destroy],
                                     reward_attributes: [:title, :image]
                                     )
  end

end
