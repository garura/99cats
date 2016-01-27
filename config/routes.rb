Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests
  post 'cat_rental_requests/:id/approve', :to => 'cat_rental_requests#approve', :as => 'request_approve'
  post 'cat_rental_requests/:id/deny', :to => 'cat_rental_requests#deny', :as => 'request_deny'
end
