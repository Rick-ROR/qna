class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  expose :questions, ->{ Question.all.order(created_at: :desc) }
  expose :question, -> { params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new }

  def index
    render json: questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question
  end

  def create
    @question = current_resource_owner.author_questions.new(question_params)
    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, question
    if question.update(question_params)
      render json: question
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    render json: {}, status: :ok
  end

  private

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     links_attributes: [:name, :url, :id, :_destroy]
                                     )
  end
end
