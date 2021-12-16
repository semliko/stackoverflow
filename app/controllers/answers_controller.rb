class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :new, :edit, :create]
  before_action :load_answer, only: [:show]

  def index
    @answers = @question.answers
  end

  def show

  end

  def new
    @question.answers.build
  end

  def edit

  end

  def create

    @answer = @question.answers.create(answer_params)

    if @answer.save
      redirect_to question_answer_path(@question, @answer)
    else
      render :new
    end
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
