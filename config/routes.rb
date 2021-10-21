Rails.application.routes.draw do
  get 'users/new'
  #get '/', to: 'pages#home'
  root to: 'pages#home'
  get 'contact', action: :contact, controller: :pages
  get 'about', action: :about, controller: :pages
  get 'help', action: :help, controller: :pages
  get 'signup', action: :new, controller: :users
  # For details on the DSL available within this file,
  # see https://guides.rubyonrails.org/routing.html
end
