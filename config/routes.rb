Rails.application.routes.draw do
  
  
  get 'sessions/new'

  get '/' => 'ct_controller#index'
  get '/share' => 'ct_controller#share'
  get '/index' => 'ct_controller#index'
  get '/about' => 'ct_controller#about'
  get '/login' => 'ct_controller#login'
  get '/contact' => 'ct_controller#contact'
  
  post 'login_request' => 'ct_controller#login_request'
  post '/fileUploader' => 'ct_controller#fileUploader'
  post '/titleUploader' => 'ct_controller#titleUploader'
  post '/storyUploader' => 'ct_controller#storyUploader'
  post '/placeUploader' => 'ct_controller#placeUploader'
  
  
  
  # get 'places/hampi' => 'places#hampi'
  # get 'places/khajjiar_dalhousie' => 'places#khajjiar_dalhousie'
  # get 'places/ananthagiri' => 'places#anathagiri'
  get 'places/:id' => 'places#get_place'
  
  
  

  
  

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
