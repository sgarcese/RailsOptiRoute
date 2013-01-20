RouteOptimization::Application.routes.draw do
  authenticated :user do
    resources :routes
    resources :locations do
      collection do
        post :verify_collection
      end
    end
    root :to => "routes#new"
  end

  devise_scope :user do
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end
  
  devise_for :users, :controllers => { :confirmations => "confirmations" }
  root :to => "pages#landing"
end
