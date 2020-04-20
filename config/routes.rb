require 'subdomain'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  root 'waitlists#index'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  mount AudioUploader::UploadEndpoint, at: 'upload/audio'
  mount ImageUploader::UploadEndpoint, at: 'upload/image'

  resources :charts, only: :index
  resources :home, only: :index
  resources :users

  resource :session, only: [:new, :create, :destroy] do
    get :profile, on: :member
  end

  resources :password_resets, except: [:index, :show, :destroy]
  resources :likes,   only: [:create, :update, :destroy]

  resource :profile,  only: [:show, :update]
  resource :waitlist, only: [:create, :update, :index]

  resources :soundbites, except: [:show]
  resources :battleground
  resources :stores
  resources :notifications

  resources :comments do
    get 'usernames', on: :member
  end

  resources :artists do
    get :viewer_side_unpopulated
    get :user_side_about
    get :user_side_first_time
    get :viewer_side_populated
    get :track_list
  end

  constraints(Subdomain) do
    get '/'     => 'artists#show'
    get '/edit' => 'artists#edit'
  end

  resources :conversations do
    resources :messages do
      collection do
        post :typing
      end
    end

    collection do
      get :inbox
      get :all, action: :index
      get :sent
      get :trash
    end
  end

  resources :beats, only: :index

  get '/callback' => 'sessions#callback'
  get '/soundcloud' => 'sessions#soundcloud'
  get '/auth/:provider/callback' => 'sessions#callback', as: :auth_callbacks
  get '/signin', to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  get '/waitlist/:token/activate', to: 'waitlists#update'
  get '/waitlists/email_confirm'
  get '/waitlists/share'

  get '/invite/:referrer_id', to: 'waitlists#index', as: :invite_member

  resources :tracks do
    resources :comments
  end

  resources :soundcloud_tracks

  get 'critiques/:track_id' => 'critiques#show', as: :critique

  get 'ratings/create' => 'ratings#create_or_update'

  get '/sync' => 'tracks#sync'

  post 'beats/toggle_marked/:track_id' => 'tracks#update'
  get 'like/:track/:star' => 'ratings#create_or_update', as: :cou_like

  get '/:id' => 'shortener/shortened_urls#show'
  get 'beats/:track_id/social_share' => 'beats#social_share', as: :social_share

  namespace :admin do
    resource :dashboard, only: :show
    resource :session, only: [:new, :create, :destroy]
  end

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USER'] && password == ENV['SIDEKIQ_PASSWORD']
  end if Rails.env.production? || Rails.env.staging?
  mount Sidekiq::Web, at: '/sidekiq/dashboard'
end
