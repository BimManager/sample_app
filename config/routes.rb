Rails.application.routes.draw do
#  #get '/', to: 'pages#home'
  root to: 'pages#home'
  get 'contact', action: :contact, controller: :pages
  get 'about', action: :about, controller: :pages
  get 'help', action: :help, controller: :pages
  get 'signup', action: :new, controller: :users
  
  resources :users
end
