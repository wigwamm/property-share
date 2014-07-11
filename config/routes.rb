require "resque_web"

Propertyshareio::Application.routes.draw do

  mount ResqueWeb::Engine => "admin/resque_web"

  # post "texts/incoming" => "texts#incoming", :as => :incoming_texts
  post "texts/incoming" => "texts#direct", :as => :incoming_texts

  get "what_is_property_share" => "static_pages#details", :as => :details
  get "register" => "agencies#new", :as => :new_agency
  get "thanks" => "static_pages#thanks", :as => :thanks
  post "register" => "agencies#create"

  authenticated :agent do
    root to: "dashboards#agent", :as => "agent_root"
  end

  devise_scope :agent do
    root "registrations#new"
  end

  devise_for :agents, 
    :path => "agent", 
    :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register"}, 
    :controllers => {:sessions => "sessions", :registrations => "registrations"}

  # resources :shares
  resources :users, only: [:create]
  resources :visits, only: [:create]
  resources :properties, :path => "" do
    get 'book'
    post 'share'
  end
  resources :availabilities, only: [:create, :destroy]

  get "*path" => "registrations#new"
  
end

