module UserQuestion
  extend ActiveSupport::Concern

  included do
    before_action :load_question, only: %i[show edit update destroy mark_best_answer delete_attached_file subscribe]

    after_action :publish_question, only: [:create]
    helper_method :question
    authorize_resource
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @awards = @question.awards
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer.links.new
    @comments = @answer.comments
  end

  def new
    @question = Question.new
    @question.links.new
    @question.awards.new
  end

  def edit
    @question.links.new if @question.links.empty?
    @question.awards.new if @question.awards.empty?
  end

  def create
    @question = Question.create(question_params)
    @question.user_id = current_user.id

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question.user.id) &&
       @question.update(question_params)
      redirect_to @question
    elsif api_request?
      render json: { error: 'fail to upate' }
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  def mark_best_answer
    @answer = Answer.find(params[:answer_id])
    user_id = @answer.user.id
    if current_user.author_of?(user_id)
      @question.update_best_answer(@answer.id)
      @question.assign_awards
      @question.award_user(user_id)
    end
    redirect_to @question
  end

  def subscribe
    current_user.subscriptions.create(subscriwable: @question)
  end

  def unsubscribe
    subscription = Subscription.where(user_id: current_user.id, subscriwable_type: 'Question',
                                      subscriwable_id: @question.id).first
    subscription&.destroy
  end

  private

  def api_request?
    request.path.include?('/api/')
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def initialize_links
    @question.links.new
  end

  def publish_question
    ActionCable.server.broadcast 'questions_channel',
                                 ApplicationController.render(
                                   partial: 'questions/question',
                                   locals: { question: @question }
                                 )
  end

  # helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url], awards_attributes: %i[name file])
  end
end
