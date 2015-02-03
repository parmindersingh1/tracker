Rails.application.routes.draw do
  # resources :tracks

  get 'admin_panel/users'

  get 'admin_panel/edit_role'
  post 'admin_panel/update_role'
  
  get 'tracks/display_map'
  get 'tracks/getallroutesformap'
  get 'tracks/getrouteformap'
  get 'tracks/getroutes'
  post 'tracks/updatelocation'
  get 'tracks/deleteroute'
  
    
  devise_for :users, :controllers => {sessions: 'sessions', :passwords => "passwords"}
  
  # devise_for :users, :controllers => { :sessions => "api/v1/sessions" }
  # devise_scope :user do
    # namespace :api do
      # namespace :v1 do
        # resources :sessions, :only => [:create, :destroy]
      # end
    # end
  # end

resources :users

  # devise_for :users, skip: :registrations, controllers: { sessions: "sessions", passwords: "passwords" }
  resources :schools

  resources :stops do
  collection do
      post  :create_route_stops
    end
  end

  resources :routes do
   collection do
      get  :user_routes
    end
  end

  resources :devices

  resources :vehicles do
   collection do
      get  :user_vehicles
    end
  end
  root 'tracks#display_map'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
