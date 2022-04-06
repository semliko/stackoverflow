Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'
  resources :attached_files, only: [:destroy]
  resources :questions do
    patch 'mark_best_answer', to: 'questions#mark_best_answer', on: :member
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
    end
  end
end
