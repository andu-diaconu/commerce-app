Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :products
  resources :favorites
  resources :reviews
  resources :carts
  resources :orders
  resources :brands
  resources :rooms do
    resources :messages
  end
  resources :users
  resources :discounts

  
  post "users/:id/toggle_favorite/:product_id" => "users#toggle_favorite", as: "toggle_product"
  get "checkout-cart/" => "carts#checkout_cart", as: "my_cart"
  get "remove-item/:product_id" => "carts#remove_item", as: "remove_item_from_cart"
  post "update_cart_quantity" => "carts#update_qty", as: "update_cart_quantity"
  post "empty-cart/" => "carts#empty_cart", as: "empty_cart"
  post "users/:id/let_mew_know/:product_id" => "users#let_me_know", as: "let_me_know"
  get "sales_report" => "orders#sales_report", as: "sales_report"
  post "create_staff" => "brands#create_staff", as: "create_staff"
  post "products/:id/rating" => "products#receive_rating", as: "rate_product"
end
