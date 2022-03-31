Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :endpoints, only: [:index, :create, :update, :destroy]

  match '*path' => 'mocks#mock', via: [:get, :head, :post, :put, :patch, :delete, :connect, :options, :trace], constraints: -> (req) { !(req.fullpath =~ /^\/rails\/.*/) }
end
