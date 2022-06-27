Rails.application.routes.draw do
  #  get 'users/show'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  mount ActionCable.server => '/cable'

  concern :votable do
    patch 'make_vote', action: 'make_vote', on: :member
  end

  concern :commentable do
    post 'make_comment', action: 'make_comment', on: :member
  end

  resources :attached_files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :questions, concerns: %i[votable commentable] do
    resources :votes, defaults: { votable: 'questions' }
    patch 'mark_best_answer', to: 'questions#mark_best_answer', on: :member

    resources :answers, shallow: true, concerns: %i[votable commentable], only: %i[create update destroy] do
      resources :votes, defaults: { votable: 'answers' }
    end
  end
  resources :users, only: [:show]
end
