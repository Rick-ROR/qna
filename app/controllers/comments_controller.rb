class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose :Comments, ->{ Comment.all }
  expose :Comment, -> { params[:id] ? Comment.find(params[:id]) : Answer.new }
  expose :question

  def create
    @comment = question.comments.new(comment_params)
    @comment.author = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
