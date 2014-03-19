Propertyshareio::Application.routes.draw do
  require "resque_web"

  mount ResqueWeb::Engine => "resque_web"
  ResqueWeb::Engine.eager_load!

  post "texts/incoming", to: "texts#incoming", as: :incoming_texts

  get "what_is_property_share", to: "static_pages#details",   as: :details
  get "register",               to: "agencies#new",           as: :new_agency
  get "thanks",                 to: "static_pages#thanks",    as: :thanks
  post "register",              to: "agencies#create"

  authenticated :agent do
    root to: "dashboards#agent", as: "agent_root"
  end  
  root "agencies#new"

  resources :availabilities,  only: [:create, :destroy]
  resources :users, only: [:create]
  resources :visits, only: [:create]
  resources :images, only: [:create, :show]

  devise_for :agents, 
              path: "agent", 
              path_names: { sign_in: "login", sign_out: "logout", sign_up: "register"}, 
              controllers: { sessions: "sessions",  registrations: "registrations"}

  resources :agency, path: "", only: [:create] do
    get "testajax", to: "properties#ajaxtest", as: :ajaxtest
    resources :properties, path: "", only: [:new, :show, :create]
  end


  get "*path", to: "agencies#new"

end

