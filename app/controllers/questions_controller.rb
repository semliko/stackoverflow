class QuestionsController < ApplicationController
  include UserVote
  include UserComment
  include UserQuestion

  before_action :authenticate_user!, except: %i[index show delete_attached_file]
end
