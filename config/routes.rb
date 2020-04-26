Rails.application.routes.draw do
  root to: 'home#welcome'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    sessions: 'users/sessions'
  }

  get '/send/:id', to: 'friend_requests#send_request', as: :send_friend_request
  get '/accepted/:id', to: 'friend_requests#accept', as: :accepted
  delete '/denied/:id', to: 'friend_requests#deny', as: :friend_request

  get '/users/seek', to: 'users#seek'
  get '/friends', to: 'users#friends'
  delete '/unfriend/:id', to: 'users#unfriend', as: :unfriend
end
