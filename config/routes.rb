Rails.application.routes.draw do
  resources :tasks
  root to: 'tasks#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only:[:new, :create, :show, :edit, :update, :destroy]
  resources :sessions, only:[:new, :create, :destroy]
  namespace :admin do
    resources :users
  end
end
