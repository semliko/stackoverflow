class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :load_question, only: [:index, :new, :edit, :create]
  before_action :load_answer, only: [:show, :update, :destroy, :edit]

  def index
    @answers = @question.answers
  end

  def show

  end

  def new
    @answer = @question.answers.build
  end

  def edit

  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @question = @answer.question
    @answer.update(answer_params) if current_user.author_of?(@answer)
    redirect_to @question
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
