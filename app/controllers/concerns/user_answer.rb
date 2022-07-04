module UserAnswer
  extend ActiveSupport::Concern

  included do
    before_action :load_question, only: %i[index new edit create]
    before_action :load_answer, only: %i[show update destroy edit delete_attached_file]

    after_action :publish_answer, only: [:create]
    #  authorize_resource
  end

  def new
    @answer = @question.answers.build
    @answer.links.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @question = @answer.question
    @answer.update(answer_params) if current_user.author_of?(@answer.user.id)
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer.user.id)
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body, files: [],
                                                        links_attributes: %i[name url])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    ActionCable.server.broadcast 'answers_channel',
                                 render_to_string(
                                   partial: 'answers/answer',
                                   locals: { answer: @answer }
                                 )
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
