class AnswersController < ApplicationController
  include UserVote
  include UserComment
  include UserAnswer

  before_action :authenticate_user!, only: %i[create update destroy delete_attached_file]
end
