Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users do
    resources :transactions
    get :loans, to: "users#loaned_books", on: :member
  end
  resources :books do
    resources :transactions
    get :income, on: :member
  end
end