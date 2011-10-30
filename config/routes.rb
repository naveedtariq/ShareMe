ShareMe::Application.routes.draw do
  get "feedbacks/new"

  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "omniauth_callbacks","invitations"=>"invitations"} do
    get "logout", :to => "devise/sessions#destroy"
    get 'omniauth_callbacks/oauth_data' => 'omniauth_callbacks#oauth_data'
    post 'omniauth_callbacks/clear_omniauth' => 'omniauth_callbacks#clear_omniauth'
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
    get '/users/auth/:provider/callback' => 'omniauth_callbacks#aho'
    get '/invitations/accept' => 'invitations#edit'
    post '/invitations/update' => 'invitations#update'
  end

  resources :users
  resources :profiles
  resources :contacts
  resources :groups
  resources :feedbacks do
  	get 'thanks', :on => :collection
  end
  
  match 'contactus' , :controller => 'feedbacks', :action => 'new'


#  get "activations/new"

#  get "activations/create"

#  get "user_sessions/new"

#  match 'authenticate' => 'user_sessions#create', :as => :authenticate, :via => :post
#	match 'login' => "user_sessions#new",      :as => :login
#	match 'logout' => "user_sessions#destroy", :as => :logout
	root :to  => 'home#index'
	match '/user_home', :controller => 'users', :action => 'user_home', :as => :user_home
  match 'search/(:code)', :controller => 'contacts', :action => "search", :as => :search
  match 'import_contacts', :controller => 'contacts', :action => "import_contacts", :as => :import_contacts
  match 'get_facebook_friends', :controller => 'contacts', :action => "get_facebook_friends", :as => :get_facebook_friends
  match 'post_on_wall', :controller => 'contacts', :action => "post_on_wall", :as => :post_on_wall
  match 'show_basic_profile(:id)', :controller => 'contacts', :action => "show_basic_profile", :as => :show_basic_profile
  match '/get_facebook_feed', :controller => 'users', :action => 'get_facebook_feed', :as => :get_facebook_feed
  match '/get_tweets', :controller => 'users', :action => 'get_tweets', :as => :get_tweets
  match '/get_linkedin', :controller => 'users', :action => 'get_linkedin', :as => :get_linkedin
  match '/socialify', :controller => 'users', :action => 'socialify', :as => :socialify
  match '/group/change/(:id)', :controller => 'groups', :action => 'change'
  match '/group/update', :controller => 'groups', :action => 'update'
  match '/what_is_share_me', :controller => 'home', :action => 'about'
  match '/how_share_me_works', :controller => 'home', :action => 'how'

#  match '/users/update_user_for_password', :controller => 'users', :action => 'update_user_for_password'
#	resources :user_sessions
#	resources :users do
# end
	 
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id(.:format)))'
end
