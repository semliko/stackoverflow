module UserComment
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:make_comment]
    after_action :publish_comment, only: [:make_comment]
  end

  def make_comment
    binding.pry
    votable_obj = model_klass.find(params[:id])
    vote_type = params[:vote][:vote_type]
    votable_obj.comments.upsert(
      { vote_type: vote_type,
        user_id: current_user.id,
        votable_type: model_klass.name,
        votable_id: votable_obj.id }, unique_by: %i[votable_id votable_type user_id]
    )
    respond_to do |format|
      format.json { render json: votable_obj.votes_count }
    end
  end

  private

  def publish_comment
    ActionCable.server.broadcast 'comments_channel',
                                 ApplicationController.render(
                                   partial: 'comments/comment',
                                   locals: { comment: @comment }
                                 )
  end

  def vote_params
    params.require(:comment).permit(:id, :body, :comment)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @votable = model_klass.find(params[:id])
  end
end
