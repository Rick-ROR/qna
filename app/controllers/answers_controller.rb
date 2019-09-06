class AnswersController < ApplicationController

  before_action :authenticate_user!

  include Voted

  expose :answers, ->{ Answer.all }
  expose :answer, -> { params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new }
  expose :question

  after_action :pub_answer, only: :create

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @question = answer.question
    may?(answer) ? answer.update(answer_params) : no_rights(@question)
  end

  def destroy
    may?(answer) ? answer.destroy : no_rights(answer.question)
  end

  def best
    may?(answer.question) ? answer.make_best : no_rights(answer.question)
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
