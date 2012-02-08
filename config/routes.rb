Challenger2::Application.routes.draw do
  
  root :to => 'sessions#new'
  #root :to => 'sessions#new'
  
  resources :crm_member_lists
  resources :sessions, :only => [:new, :create, :destroy]

 
  resources :crm_member_lists do
    resources :crm_redemption_reservations
  end

  resources :crm_redemption_reservations
  
  resources :crm_product_lists
  resources :crm_redemption_locations  
  
  resources :crm_redemption_lists do    
    resources :crm_redemption_reservations
  end 
  
  match '/signup' => 'crm_member_lists#new' ,:as=> :signup
  match '/signin' => 'sessions#new', :as=>:signin
  match '/signout' => 'sessions#destroy'
  match '/crm_member_lists/:id' =>'crm_member_lists#show', :as => :home
  match '/crm_redemption_lists' => 'crm_redemption_lists#index', :as => :redemption
  match '/crm_redemption_lists/:id' => 'crm_redemption_lists#show', :as => :redeemdetails
  match '/crm_redemption_lists/:id/crm_redemption_reservations/:id' => 'crm_redemption_reservations#show', :as => :reservation
  match '/crm_redemption_reservations' => 'crm_redemption_reservations#index', :as => :redeemhistory
  match '/rebate' => 'crm_redemption_reservations#rebate', :as => :rebate
  match '/crm_redemption_locations' =>'crm_redemption_locations#index', :as => :location
  match '/destroy/:id' => 'crm_redemption_reservations#destroy' , :as => :destroy
  match '/detail/:id' => 'crm_member_lists#detail' , :as => :detail
  match '/change/:id' => 'crm_member_lists#change' , :as => :change
  #match '/status/:id' => 'crm_member_lists#status' , :as => :status
  match '/statuscheck/:id' => 'crm_member_lists#statuscheck' , :as => :status
  
  match '/renew/:id' => 'crm_member_lists#renew' , :as => :renew
  match '/crm_member_transactions' => 'crm_member_transactions#index' , :as => :transaction
  match '/transaction_filter' => 'crm_member_transactions#filter' , :as => :filter

  

  #match '/crm_redemption_lists/:id' => 'crm_redemption_lists#show' ,:as => :redeemdetails
  #resources :crm_member_transactions,:only => [:index, :show]
  

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
