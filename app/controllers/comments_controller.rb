class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose :Comments, ->{ Comment.all.order(created_at: :desc) }
  before_action :set_commentable, only: :create

  after_action :pub_comment, only: :create

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

  def pub_comment
    return if @comment.errors.any?

    id = @commentable.class == Question ? @commentable.id : @commentable.question_id

    CommentsChannel.broadcast_to(
      id,
      type: @comment.commentable_type.downcase,
      id: @comment.commentable_id,
      author: @comment.author_id,
      view: ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: @comment }
      )
    )
  end

end
