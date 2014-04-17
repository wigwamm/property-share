require "resque_web"

Propertyshareio::Application.routes.draw do

  resources :availabilities

  # get     'availabilities/:agent_id',         to: 'availabilities#index',     as: :availabilities
  # get     'availability/new',                 to: 'availabilities#new',       as: :new_availability
  # get     'availability/:agent_id/:id/edit',  to: 'availabilities#edit',      as: :edit_availability
  # get     'availability/:agent_id/:id',       to: 'availabilities#show',      as: :availability
  # post    'availability/:agent_id',           to: 'availabilities#create'
  # patch   'availability/:agent_id/:id',       to: 'availabilities#update'
  # put     'availability/:agent_id/:id',       to: 'availabilities#update'
  # delete  'availability/:agent_id/:id',       to: 'availabilities#destroy'

  resources :visitors, only: [:create, :destroy]

  devise_for :agents
  root 'static_pages#home'  

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




  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
