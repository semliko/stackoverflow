class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :new, :edit]
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

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
