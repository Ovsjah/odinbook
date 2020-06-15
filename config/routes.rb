Rails.application.routes.draw do
  root to: 'posts#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    sessions: 'users/sessions'
  }

  resources :users, only: %i[show edit update]
  resources :posts, except: %i[new show edit] do
    resources :images, only: :destroy
  end
  resources :comments, only: %i[create update destroy]

  get '/send/:id', to: 'friend_requests#send_request', as: :send_friend_request
  get '/accepted/:id', to: 'friend_requests#accept', as: :accepted
  delete '/denied/:id', to: 'friend_requests#deny', as: :friend_request

  get '/seek', to: 'users#seek'
  get '/friends', to: 'users#friends'
  delete '/unfriend/:id', to: 'users#unfriend', as: :unfriend
  get '/like/:post_id', to: 'users#like'
  get '/dislike/:post_id', to: 'users#dislike'
end
