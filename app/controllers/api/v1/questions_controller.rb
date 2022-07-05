class Api::V1::QuestionsController < Api::V1::BaseController
  include UserQuestion

  def index
    render json: super
  end

  private

  def current_user
    @current_user ||= User.find(doorkeeper_token[:resource_owner_id])
  end
end
