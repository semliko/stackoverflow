class QuestionsController < ApplicationController
  include UserVote
  include UserComment
  include UserQuestion

  before_action :authenticate_user!, except: %i[index show delete_attached_file]
  #  before_action :load_question, only: %i[show edit update destroy mark_best_answer delete_attached_file]
  #
  #  after_action :publish_question, only: [:create]

  #  authorize_resource

  #  def index
  #    authorize! :read, Question
  #    @questions = Question.all
  #  end
  #
  #  def show
  #    authorize! :read, @question
  #    @answer = Answer.new
  #    @awards = @question.awards
  #    @best_answer = @question.best_answer
  #    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  #    @answer.links.new
  #    @comments = @answer.comments
  #  end
  #
  #  def new
  #    authorize! :create, Question
  #    @question = Question.new
  #    @question.links.new
  #    @question.awards.new
  #  end
  #
  #  def edit
  #    @question.links.new if @question.links.empty?
  #    @question.awards.new if @question.awards.empty?
  #  end
  #
  #  def create
  #    @question = Question.create(question_params)
  #    @question.user_id = current_user.id
  #
  #    if @question.save
  #      redirect_to @question, notice: 'Your question successfully created.'
  #    else
  #      render :new
  #    end
  #  end
  #
  #  def update
  #    if current_user.author_of?(@question.user.id) &&
  #       @question.update(question_params)
  #      redirect_to @question
  #    else
  #      render :edit
  #    end
  #  end
  #
  #  def destroy
  #    authorize! :read, @question
  #    @question.destroy
  #    redirect_to questions_path
  #  end
  #
  #  def mark_best_answer
  #    @answer = Answer.find(params[:answer_id])
  #    user_id = @answer.user.id
  #    if current_user.author_of?(user_id)
  #      @question.update_best_answer(@answer.id)
  #      @question.assign_awards
  #      @question.award_user(user_id)
  #    end
  #    redirect_to @question
  #  end
  #
  #  private
  #
  #  def load_question
  #    @question = Question.with_attached_files.find(params[:id])
  #  end
  #
  #  def initialize_links
  #    @question.links.new
  #  end
  #
  #  def publish_question
  #    ActionCable.server.broadcast 'questions_channel',
  #                                 ApplicationController.render(
  #                                   partial: 'questions/question',
  #                                   locals: { question: @question }
  #                                 )
  #  end
  #
  #  helper_method :question
  #
  #  def question_params
  #    params.require(:question).permit(:title, :body, files: [],
  #                                                    links_attributes: %i[name url], awards_attributes: %i[name file])
  #  end
end
