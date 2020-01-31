class AnswersController < ApplicationController

  before_action :authenticate_user!

  include Voted

  expose :answers, ->{ Answer.all }
  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }
  expose :question

  authorize_resource

  after_action :pub_answer, only: :create

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    authorize! :update, answer
    answer.update(answer_params)
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  def best
    authorize! :best, answer
    answer.make_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body,
                                   Voted::STRONG_PARAMS,
                                   files: [],
                                   links_attributes: [:name, :url, :id, :_destroy]
                                  )
  end

  def pub_answer
    return if @answer.errors.any?

    AnswersChannel.broadcast_to(
      @answer.question,
      answer: @answer,
      files: @answer.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } },
      links: @answer.links.select(&:persisted?)
    )
  end

end
