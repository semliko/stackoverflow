
class AttachedFilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge_later if current_user.author_of?(@file.record.user_id)
    redirect_back(fallback_location: root_path)
  end
end
