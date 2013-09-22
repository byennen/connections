CahootsConnect::Application.routes.draw   do

  resources :universities, only: [:index, :show] do
    resources :updates, only: [:new, :create, :update, :destroy] do
      resources :comments
    end
    resources :clubs, only: [:show, :new, :create, :edit, :update] do
      post 'transfer_ownership', on: :member 
      resources :memberships do
        post 'make_admin', on: :collection
        post 'remove_admin', on: :member
      end
      resources :invitations
      resources :club_photos
      resources :club_events
      resources :statuses
      resources :records
      resources :club_newsletters do 
        resources :comments
      end
    end
  end
  resources :updates do
    resources :comments 
  end

  match '/signup/:invitation_token', to: 'memberships#new', as: 'signup'


  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :users do
    resources :profiles
    resource :profile
    match '/skip', to: 'profiles#skip', as: 'skip_profile'
  end

  namespace :admin do
    resources :universities
    resources :locations
    resources :clubs
    resources :users
    root to: 'dashboard#index'
  end

  root :to => "home#index"
end
