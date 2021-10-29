Rails.application.routes.draw do
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :microposts, :only => [:create, :destroy]

#  #get '/', to: 'pages#home'
  root to: 'pages#home'
  get 'contact', action: :contact, controller: :pages
  get 'about', action: :about, controller: :pages
  get 'help', action: :help, controller: :pages
  get 'signup', action: :new, controller: :users
  get 'signin', action: :new, controller: :sessions
  delete 'signout', action: :destroy, controller: :sessions
end
