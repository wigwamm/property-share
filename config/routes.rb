require "resque_web"

Propertyshareio::Application.routes.draw do

  mount ResqueWeb::Engine => "admin/resque_web"

  post "texts/incoming", to: "texts#incoming", as: :incoming_texts

  get "what_is_property_share", to: "static_pages#details",   as: :details
  get "register",               to: "agencies#new",           as: :new_agency
  get "thanks",                 to: "static_pages#thanks",    as: :thanks
  post "register",              to: "agencies#create"

  authenticated :agent do
    root to: "dashboards#agent", as: "agent_root"
  end
  
  root "agencies#new"

  devise_for :agents, 
    path: "agent", 
    path_names: { sign_in: "login", sign_out: "logout", sign_up: "register"}, 
    controllers: { sessions: "sessions",  registrations: "registrations"}


  resources :users, only: [:create]
  resources :visits, only: [:create]
  resources :properties, path: "", except: [:show]
  resources :availabilities,  only: [:create, :destroy]

  resources :agency, path: "" do
    resources :properties, path: "", only: [:show]
  end

  get "*path", to: "agencies#new"

end

