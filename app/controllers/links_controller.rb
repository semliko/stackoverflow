
class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if current_user.author_of?(@link.linkable.user_id)
    redirect_back(fallback_location: root_path)
  end
end
