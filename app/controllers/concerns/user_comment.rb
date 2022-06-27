module UserComment
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:make_comment]
    after_action :publish_comment, only: [:make_comment]
  end

  def make_comment
    commentable_obj = model_klass.find(params[:id])
    @comment = commentable_obj.comments.new(comment_params)
    @comment.save
  end

  private

  def publish_comment
    ActionCable.server.broadcast 'comments_channel',
                                 ApplicationController.render(
                                   partial: 'comments/comment',
                                   locals: { comment: @comment }
                                 )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @votable = model_klass.find(params[:id])
  end
end
