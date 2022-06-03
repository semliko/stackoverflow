module UserVote
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:make_vote]
  end

  def make_vote
    votable_obj = model_klass.find(params[:id])
    vote_type = params[:vote][:vote_type]
    votable_obj.votes.upsert(
      {vote_type: vote_type,
       user_id: current_user.id,
       votable_type: model_klass.name,
       votable_id: votable_obj.id }, unique_by: [:votable_id, :votable_type, :user_id])
  end

  private

  def vote_params
    params.require(:vote).permit(:id, :vote)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
