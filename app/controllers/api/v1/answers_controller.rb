class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer

  expose :question
  expose :answers, ->{ question.answers }
  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }

  def index
    render json: answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, answer
    if answer.update(answer_params)
      render json: answer
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
    render json: {}, status: :ok
  end


  private

  def answer_params
    params.require(:answer).permit(:body,
                                   links_attributes: [:name, :url, :id, :_destroy]
    )
  end
end
