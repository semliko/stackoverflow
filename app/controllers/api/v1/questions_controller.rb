class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions
  end

  def update
    @question = Question.find params['id']
    @question.update(params['question']) if @question
  end
end
