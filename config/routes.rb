Rails.application.routes.draw do

  
  resources :reportes, :path => '/'
  
  get 'mainlayout/navsidebar', to: 'mainlayout#navsidebar'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
