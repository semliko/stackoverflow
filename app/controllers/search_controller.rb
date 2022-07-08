class SearchController < ApplicationController
  before_action :authenticate_user!, except: %i[index show delete_attached_file]

  def index
    @results = search_results
    render :index
  end

  private

  def search_results
    search_params = params['search']
    search_terms = search_params.split(':')
    if search_terms.length > 1
      Question.search search_terms[1] if search_terms.first == 'questions'
      Answer.search search_terms[1] if search_terms.first == 'answers'
      User.search search_terms[1] if search_terms.first == 'users'
    else
      ThinkingSphinx.search(search_params)
    end
  end
end
