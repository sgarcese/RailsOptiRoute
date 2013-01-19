RouteOptimization::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end

  devise_scope :user do
    root :to => "devise/registrations#new"
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end
  devise_for :users, :controllers => { :confirmations => "confirmations" }
  root :to => "home#index"
end
