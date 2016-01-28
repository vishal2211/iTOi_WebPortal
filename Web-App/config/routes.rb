Rails.application.routes.draw do

  get '/relay' => 'nowrelay#index'
  match '/relay/addAuth' => 'nowrelay#addAuth', via: [:post]
  get '/relay/company' => 'nowrelay#company'
  get '/relay/resendAuth' => 'nowrelay#resendAuth'
  match '/relay/createCompany' => 'nowrelay#createCompany', via: [:post]
  match '/relay/createCompanyUser' => 'nowrelay#createCompanyUser', via: [:post]
  match '/relay/checkUser' => 'nowrelay#checkUser',  via: [:post]
  match '/relay/cancelUser' => 'nowrelay#cancelUser',  via: [:post, :get]
  ##post '/relay/createCompany' => 'nowrelay#createCompany'



  resources :companies do
    member do
      get :recordings
    end
    resources :media_items
    resources :users do
      collection do
        match 'invite' => 'users#invite', via: [:post]
        post :manual_create
      end
    end
  end

  resources :templates

  resources :user_records, only: [:index]

  resources :plans

  resources :app_builds do
    member do
      get :manifest
    end
  end

  resources :recordings do
    resources :palette_images
    member do
      get 'play/:token' => 'recordings#play'
    end
  end

  get '/documentation' => 'documentation#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  devise_for :users
  get '/me' => "accounts#show"
  resource :account do
    member do
      get :password
      put :update_password
    end
  end

  resources :users, only: [:show]

  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :users, :except => [:show] do
        collection do
          get :me
          post :reset_password
          post :bump_subscription
        end
      end
      resources :recordings do
        collection do
          get :stats
        end
      end
      resources :media
      resources :callbacks do
        collection do
          post :fail
          post :success
        end
      end
    end
  end

  namespace :admin do
    get '/' => 'index#index'
  end

end
