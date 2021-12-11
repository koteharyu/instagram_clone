# == Route Map
#

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'posts#index'

  get '/signup', to: 'users#new'
  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :users, only: %i[index show create]
  resources :posts, shallow: true do
    resources :comments
    collection do
      get :search
    end
  end
  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :notifications, only: %i[] do
    resource :read, only: %i[update]
  end


  namespace :mypage do
    resource :account, only: %i[edit update]
    resources :notifications, only: %i[index]
    resource :setting_notification, only: %i[edit update]
  end

  require 'sidekiq/web'
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
