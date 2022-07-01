class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    head current_resource_owner
  end
end
