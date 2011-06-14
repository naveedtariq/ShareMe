Informer::Application.routes.draw do
  root :to => "shareme#index"
  match 'shareme/(:code)' => "shareme#show", :as => "shareme_code"

  # Devise
  #
  devise_for :users, :path => "",  :path_names => {
    :sign_in      => 'login',
    :sign_out     => 'logout',
    :password     => 'secret',
    :confirmation => 'verification',
    :unlock       => 'unblock',
    :registration => 'register'
  } , :controllers => {
    :registrations      => 'registrations',
    :confirmations      => "confirmations",
    :omniauth_callbacks => "omniauth_callbacks",
    :invitations        => "dashboard/invitations"
  }

  devise_scope :user do
    match 'register/finish' => 'registrations#finish', :as => :finish_register, :via => [:get, :put]
  end


  # Dashboard
  #
  namespace :dashboard do
    root :to => "users#show"
    resource :users, :only => [:show, :edit, :update,:update_signin_fb_flag]
    resource :codes, :only => [:new, :create]
    resources :contacts, :only => [:index, :show, :new, :create, :destroy] do
      get :level2
    end
    resource :upload_contacts, :only => [:new, :create]
    resources :maps, :only => [:index, :show]
    resources :import_contacts, :only => [:index]


    scope :module => :import_contacts do
      match "friends/facebook" => "facebook#friends", :as => :facebook_friends
      match "imports/facebook" => "facebook#imports", :as => :facebook_imports
      match "invite/facebook" => "facebook#invite",  :as => :facebook_invite
    end


  end


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
  # match ':controller(/:action(/:id(.:format)))'
end
