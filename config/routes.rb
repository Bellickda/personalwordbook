Personaldiary::Application.routes.draw do
  resources :groups

  get "explain/explain", :as => "explain"
  get "explain/kiyaku", :as => "kiyaku"
  get "explain/policy", :as => "policy"

  put "others/category", :as => "category"
  get "others/default", :as => "default"
  get "others/set", :as => "set"
  get "others/categoryd", :as => "categoryd"
  get "others/destroy", :as => "destroy"
  
  devise_for :users, :controllers => { :sessions => "users/sessions",
                                       :registrations => "users/registrations",
                                       :passwords => "users/passwords",
                                       :registrations => 'registrations' }

  resources :accounts do
    collection do
      # get "accounts/twitter/:id" => "accounts#twitter", :as => "twitter"
      get "accounts/facebook/:id" => "accounts#facebook", :as => "facebook"
      get "request/show/:id" => "request#show", :as => "request_show"
      get :search
      get :search2
      post "androidupdate/:id" => "accounts#androidupdate", :as => "androidupdate"
      post "androiddiarycreate/:id" => "accounts#androiddiarycreate", :as => "androiddiarycreate"
      post "androiddiaryupdate/:id/:diaryid" => "accounts#androiddiaryupdate", :as => "androiddiaryupdate"
    end
  end
  
  
  match '/auth/:provider/callback' => 'services#create'
  
  resources :services, :only => [:index, :create, :destroy]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'accounts#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
