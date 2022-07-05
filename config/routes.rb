require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  #  get 'users/show'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  mount ActionCable.server => '/cable'

  concern :votable do
    patch 'make_vote', action: 'make_vote', on: :member
  end

  concern :commentable do
    post 'make_comment', action: 'make_comment', on: :member
  end

  concern :questionable do
    concerns %i[votable commentable]
    patch 'mark_best_answer', to: 'questions#mark_best_answer', on: :member
  end

  concern :answerable do
    resources :answers, shallow: true, only: %i[create update destroy] do
      concerns %i[votable commentable]
    end
  end

  resources :attached_files, only: [:destroy]

  resources :links, only: [:destroy]

  resources :questions, concerns: %i[questionable] do
    resources :answers, concerns: %i[answerable]
  end

  resources :users, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, concerns: %i[questionable] do
        resources :answers, concerns: %i[answerable]
      end
    end
  end
end
