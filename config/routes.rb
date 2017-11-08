Rails.application.routes.draw do

  #Login
  root 'usuarios#login.html'
  
  #Usuario
  post 'submit_login', to: 'usuarios#login', as: :submit_login
  get 'logout', to: 'usuarios#logout'
  resources :usuarios do
    collection { post :import }
  end

  #Reporte quincenal
  resources :reporte_quincenals
  
  #Reporte semanal
  resources :reporte_semanals
  post 'reporte_semanals/valida_reporte_tutor_curso_semana', to: 'reporte_semanals#valida_reporte_tutor_curso_semana'
  
  #Conglomerado
  resources :conglomerado_semanals
  post 'conglomerado_semanals/get_semanales_count', to: 'conglomerado_semanals#get_semanales_count'
  
  #Notificaciones
  get 'get_notificaciones', to: 'notificaciones#get_notificaciones'
  get 'get_num_notificaciones', to: 'notificaciones#get_num_notificaciones'
  post 'set_notificaciones_leida', to: 'notificaciones#set_notificaciones_leida'
  
  #Alumnos
  get 'get_alumnos_by_curso', to: 'alumnos#send_alumnos_by_curso'
  
  #Cursos
  get 'get_cursos_by_tutor', to: 'cursos#send_cursos_by_tutor'
  
  #Home page
  get 'mainmenu', to: 'mainmenututor#MenuTutor.html.erb'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
