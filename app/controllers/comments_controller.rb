class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose :Comments, ->{ Comment.all.order(created_at: :desc) }
  before_action :set_commentable, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    resource, resource_id = request.path.split('/')[1, 2]
    resource = resource.singularize
    @commentable = resource.classify.constantize.find(resource_id)
  end

end
