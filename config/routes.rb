RouteOptimization::Application.routes.draw do
  authenticated :user do
    resources :routes
    resources :locations do
      collection do
        post :verify_collection
      end
    end
    root :to => 'pages#home'
  end

  devise_scope :user do
    root :to => "routes#new"
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end
  
  devise_for :users, :controllers => { :confirmations => "confirmations" }
  root :to => "home#landing"
end
