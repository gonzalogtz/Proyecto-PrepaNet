Rails.application.routes.draw do

  root 'usuarios#login.html'
  
  #Users
  post 'submit_login', to: 'usuarios#login', as: :submit_login
  get 'logout', to: 'usuarios#logout'
  
  resources :usuarios do
    collection { post :import }
  end

  #Reporte quincenal
  resources :reporte_quincenals
  
  #Reporte semanal
  resources :reporte_semanals
  post 'reporte_semanals/valida_tutor_semana', to: 'reporte_semanals#valida_tutor_semana'
  
  #Conglomerado
  resources :conglomerado_semanals
  post 'conglomerado_semanals/get_semanales_count', to: 'conglomerado_semanals#get_semanales_count'
  
  get 'get_notificaciones', to: 'usuarios#get_notificaciones'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
