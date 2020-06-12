Rails.application.routes.draw do
  
  
  root 'static_pages#home'
  get  '/help',     to: 'static_pages#help'
  get  '/about',    to: 'static_pages#about'
  get  '/contact',  to: 'static_pages#contact'
  
  get  '/signup',   to: 'users#new'
  
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
   resources :users do#resoucesメソッドはブロック付きメソッドであり引数にコードをネストすることができる
    member do#memberメソッドでusersリソースの中に新しいアクションを追加することができる
      get :following, :followers#GET	/users/1/following	アクションfollowing	名前付きルートfollowing_user_path(1)
    end                        #GET	/users/1/followers	アクションfollowers	名前付きルートfollowers_user_path(1)
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new,:create, :edit, :update]
  resources :microposts,      only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
