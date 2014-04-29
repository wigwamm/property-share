require "resque_web"

Propertyshareio::Application.routes.draw do

  resources :visitors, only: [:create, :destroy]

  root 'static_pages#home'  

  post "texts/incoming", to: "texts#incoming", as: :incoming_texts

  devise_for :agents, 
              path: "", 
              path_names: { sign_in: "login", sign_out: "logout", sign_up: "register"}, 
              controllers: { registrations: "registrations"}

  resources :agent, only: :show do
    get 'calendar',     to: 'calendar#show', as: :calendar
    resources :availabilities
  end

  resources :properties

  resources :properties, path: "", only: :show do 
    get 'calendar',     to: 'calendar#show',       as: :calendar
    resources :images,  only: [:create, :destroy]
    resources :visits
  end

  mount ResqueWeb::Engine => "/resque_web"
  ResqueWeb::Engine.eager_load!


  ########################################

  # =>  use this when admin is setup
  
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # authenticate :admin_user do #replace admin_user(s) with whatever model your users are stored in.
  #   mount ResqueWeb::Engine => "/resque_web"
  #   ResqueWeb::Engine.eager_load!
  # end

  ########################################

end
