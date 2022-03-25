class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :delete_attached_file]
  before_action :load_question, only: [:index, :new, :edit, :create]
  before_action :load_answer, only: [:show, :update, :destroy, :edit, :delete_attached_file]

  def new
    @answer = @question.answers.build
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

  def delete_attached_file
    if current_user.author_of?(@answer.user.id)
      @answer_file = ActiveStorage::Attachment.find(params[:file_id])
      @answer_file.purge_later
      redirect_to @answer.question
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body, files: [])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
