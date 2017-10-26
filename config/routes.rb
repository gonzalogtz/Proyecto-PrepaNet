Rails.application.routes.draw do

  root 'users#login.html'
  
  #Users
  resources :users
  post 'submit_login', to: 'users#login', as: :submit_login
  get 'logout', to: 'users#logout'
  
  #Reporte quincenal
  resources :reporte_quincenals
  
  #Reporte semanal
  resources :reporte_semanals
  post 'reporte_semanals/valida_tutor_semana', to: 'reporte_semanals#valida_tutor_semana'
  
  #Conglomerado
  resources :conglomerado_quincenals
  post 'conglomerado_quincenals/get_semanales_count', to: 'conglomerado_quincenals#get_semanales_count'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
