Rails.application.routes.draw do

  
  get 'sessions/new'

  get '/' => 'ct_controller#index'
  
  get '/index' => 'ct_controller#index'
  get '/about' => 'ct_controller#about'
  get '/contact' => 'ct_controller#contact'
  get '/subscribe' => 'ct_controller#subscribe'
  
  # Handles FB login.
  post 'login_request' => 'ct_controller#login_request'
  get '/ifttt' => 'ct_controller#ifttt'
  
  get '/share' => 'share#share'
  post '/fileUploader' => 'share#fileUploader'
  post '/titleUploader' => 'share#titleUploader'
  post '/storyUploader' => 'share#storyUploader'
  post '/placeUploader' => 'share#placeUploader'
  post '/discardStory' => 'share#discardStory'
  
  get '/auth/:provider/callback' => 'ct_controller#callback'
  
  get '/instagram/connect' => 'instagram#connect'
  get '/instagram/callback' => 'instagram#callback'
  get '/instagram/ifttt_instagram' => 'instagram#ifttt_instagram'
  
  get '/migrate' => 'publish#migrate'
  get '/publish' => 'publish#publish'
  get '/edit_story' => 'publish#edit_story'
  post '/edit_story_save' => 'publish#edit_story_save'
  get '/all_user' => 'publish#all_user'
  get '/all_stories' => 'publish#all_stories'
  get '/all_images' => 'publish#all_images'
  get '/attach_stories' => 'publish#attach_stories'
  post '/attach_stories_save' => 'publish#attach_stories_save'
  
  # get 'places/hampi' => 'places#hampi'
  # get 'places/khajjiar_dalhousie' => 'places#khajjiar_dalhousie'
  # get 'places/ananthagiri' => 'places#anathagiri'
  get 'places/:id' => 'places#get_place'
  
  #userprofile
  get 'user/:id' => 'user#profile'
  
  get '/edit_user_info' => 'user#edit_user_info'
  post '/edit_profile_save' => 'user#edit_profile_save'
  post '/tile_picture_save' => 'user#tile_profile_save'
  post '/cover_picture_save' => 'user#cover_profile_save'

  # Sign up
  post   'signup'   => 'user#create'

  # Sessions management.
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
 

  
  

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
