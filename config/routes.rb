ToglAdmin::Application.routes.draw do
  root "promotions#index"

  resources :user_sessions, only: [:new, :create] 
  delete "/logout", to: "user_sessions#destroy", as: "logout"
  

  resources :games, only: [] do
    resources :contest_templates, only: [:index] do
      resources :event_participants, only: [:index]
    end

    resources :event_sets, only: [:index] do
      resources :event_participants, only: [:index]
    end
  end

  resources :other_tools, only: [:index]

  resources :contest_seeds, only: [:new, :index, :edit, :create, :update, :destroy]

  resources :promotions, only: [:new, :index, :show, :edit, :create, :update] do
    collection do
      get "identifier_check"
      put "update_by_identifier"
    end
  end

  resources :users, only: [] do
    collection do
      get "search"
      get "search_csv"
      get "identity_lookup"
      get "contests_lookup"
    end
    member do
      patch "enable"
      patch "disable"
    end
  end

  post "/user_contests/:id/leave", to: "user_contests#leave"

  get "/rapi_users/csv_list", to: "rapi_users#csv_list"
  get "/rapi_users/search", to: "rapi_users#search", as: "rapi_user_search"

  resources :landing_pages, only: [:new, :index, :show, :edit, :create, :update]
  resources :landing_page_templates, only: [:show]
  resources :promotion_groups, only: [:new, :index, :show, :edit, :create, :update] do
    resources :promotion_group_schedules, only: [:index, :edit, :update, :create, :destroy]
    collection do
      get "list_for_schedules"
    end
  end

  get "/metrics", to: "metrics#choose_date_range"
  post "/metrics", to: "metrics#view"



  put "/client_apps" => "application#update_client_app"



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
