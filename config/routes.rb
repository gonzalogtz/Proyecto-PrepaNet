Rails.application.routes.draw do

  
  
  
  resources :users
  resources :reporte_quincenals
  resources :conglomerado_quincenals
  root 'mainmenututor#MenuTutor'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
