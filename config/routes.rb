Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'
  resources :questions do
    member do
      delete :delete_attached_file
    end
    patch 'mark_best_answer', to: 'questions#mark_best_answer', on: :member
    resources :answers, shallow: true, only: [:create, :update, :destroy, :delete_attached_file] do
      member do
        delete :delete_attached_file
      end
    end
  end
end
