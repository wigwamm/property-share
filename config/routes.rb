require "resque_web"

Propertyshareio::Application.routes.draw do

  resources :shares

  resources :visitors, only: [:create, :destroy]

  authenticated :agent do
    root 'properties#index', as: :agent_root
  end
  root 'static_pages#home'  

  post "texts/incoming", to: "texts#incoming", as: :incoming_texts
  get "c", to: "cookies#set", as: :cookie_set

  devise_for :agents, 
              path: "", 
              path_names: { sign_in: "login", sign_out: "logout", sign_up: "register"}, 
              controllers: { registrations: "registrations"}

  resources :agent, only: :show do
    get 'calendar',     to: 'calendar#show', as: :calendar
    resources :availabilities
  end

  resources :properties
  get 'properties/:id/pending', to: 'properties#pending', as: :pending_property
  get 'properties/:id/preview', to: 'properties#preview', as: :preview_property
  get 'properties/:id/publish', to: 'properties#publish', as: :publish_property
  post 'properties/:id/activate', to: 'properties#activate', as: :activate_property
  get 'properties/:id/share', to: 'properties#share', as: :share_property

  mount ResqueWeb::Engine => "/resque_web"
  ResqueWeb::Engine.eager_load!

  resources :properties, path: "", only: :show do
    get 'calendar',     to: 'calendar#show',       as: :calendar
    resources :images,  only: [:create, :destroy]
    resources :visits
  end

  get '/:properties_id', to: 'properties#show', as: :public_property


  ########################################

  # =>  use this when admin is setup
  
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # authenticate :admin_user do #replace admin_user(s) with whatever model your users are stored in.
  #   mount ResqueWeb::Engine => "/resque_web"
  #   ResqueWeb::Engine.eager_load!
  # end

  ########################################

end
