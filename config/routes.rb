Rails.application.routes.draw do

  root :to => "products#new"
  resources :products

  get "generate_signed_s3_url" => "aws#generate_signed_s3_url"
  
end
