class ConglomeradoSemanalsController < ApplicationController
  before_action :user_is_logged_in
  before_action :set_conglomerado_semanal, only: [:show, :edit, :update, :destroy]

  # GET /conglomerado_semanals
  # GET /conglomerado_semanals.json
  def index
    @conglomerado_semanals = ConglomeradoSemanal.where(coordinador_tutores: CUENTA)
  end

  # GET /conglomerado_semanals/1
  # GET /conglomerado_semanals/1.json
  def show
  end

  # GET /conglomerado_semanals/new
  def new
    @conglomerado_semanal = ConglomeradoSemanal.new
  end

  # GET /conglomerado_semanals/1/edit
  def edit
  end

  # POST /conglomerado_semanals
  # POST /conglomerado_semanals.json
  def create
    @conglomerado_semanal = ConglomeradoSemanal.new(conglomerado_semanal_params)
    @conglomerado_semanal[:coordinador_tutores] =  CUENTA

    # Variables calculadas a partir de los reportes semanales
    reportes_semanales = ReporteSemanal.where(tutor: @conglomerado_semanal[:tutor], coordinador_tutores: CUENTA).order('semana').take(15)
    
    #Se leen las 15 calificaciones de los reportes semanales
    calif_arr = []
    reportes_semanales.each do |reporte|
        calif_arr.push(reporte.calificacion_total)
    end
      
    @conglomerado_semanal[:calificaciones_semanales] = calif_arr.to_json()
    @conglomerado_semanal[:promedio] = calif_arr.sum.fdiv(calif_arr.size)
    @conglomerado_semanal[:horas_desempeno_semanal] =  @conglomerado_semanal[:promedio]*7.5
    @conglomerado_semanal[:horas_reportes] = 15
    @conglomerado_semanal[:total_horas] =  @conglomerado_semanal[:horas_desempeno_semanal] + @conglomerado_semanal[:horas_reportes]

    respond_to do |format|
      if @conglomerado_semanal.save
        format.html { redirect_to conglomerado_semanals_path, notice: 'Conglomerado quincenal was successfully created.' }
        format.json { render :show, status: :created, location: @conglomerado_semanal }
      else
        format.html { render :new }
        format.json { render json: @conglomerado_semanal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conglomerado_semanals/1
  # PATCH/PUT /conglomerado_semanals/1.json
  def update
    respond_to do |format|
      if @conglomerado_semanal.update(conglomerado_semanal_params)
        format.html { redirect_to conglomerado_semanals_path, notice: 'Conglomerado quincenal was successfully updated.' }
        format.json { render :show, status: :ok, location: @conglomerado_semanal }
      else
        format.html { render :edit }
        format.json { render json: @conglomerado_semanal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conglomerado_semanals/1
  # DELETE /conglomerado_semanals/1.json
  def destroy
    @conglomerado_semanal.destroy
    respond_to do |format|
      format.html { redirect_to conglomerado_semanals_url, notice: 'Conglomerado quincenal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # POST conglomerado_semanals/get_semanales
  def get_semanales_count
    response = {"tipo_error": 0}
    
    #primero checa si no hay 15 reportes semanales todavia
    reportes_semanales = ReporteSemanal.where(tutor: params[:tutor_id], coordinador_tutores: CUENTA).take(15)
    if reportes_semanales.count < 15
      response = {"tipo_error": 1}
    else
      conglomerado = ConglomeradoSemanal.where(tutor: params[:tutor_id], coordinador_tutores: CUENTA)
      
      #despues checa si ya hay un conglomerado creado
      if conglomerado.count > 0
        response = {"tipo_error": 2}
      end
    end
  
    respond_to do |format|
      format.js {render :json => response}
    end
  end

  private
    def verify_show_access(conglomerado_semanal)
      #el reporte lo puede ver el coordinador de tutores
      if (conglomerado_semanal.coordinador_tutores != CUENTA)
        
        #el tutor tambien puede ver los reportes
        if (conglomerado_semanal.tutor != CUENTA)
          redirect_to "/"
        end
      end
    end
    helper_method :verify_show_access
    
    def verify_edit_access(conglomerado_semanal)
      #el reporte lo puede editar el coordinador de tutores
      if (conglomerado_semanal.coordinador_tutores != CUENTA)
        redirect_to "/"
      end
    end
    helper_method :verify_edit_access
    # Use callbacks to share common setup or constraints between actions.
    def set_conglomerado_semanal
      @conglomerado_semanal = ConglomeradoSemanal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conglomerado_semanal_params
      params.require(:conglomerado_semanal).permit(:tutor, :curso, :invitacion_asesorias, :reporte_parcial, :reporte_final, 
      :actividad_cierre, :recomendacion_reingreso, :recomendacion_coordinador, :comentarios, :alumnos_original_acabaron, 
      :alumnos_original_aprobaron, :alumnos_final_concluyeron, :total_horas_sugerido)
    end
    
    def get_tutores
      lista_tutores = []
      
      tutores = UsuarioCoordinaUsuario.select("*").where(coordinador: CUENTA).joins("INNER JOIN usuarios ON usuario_coordina_usuarios.usuario = usuarios.cuenta")
      tutores.each do |tutor|
        nombre_tutor = tutor.nombres + " " + tutor.apellido_p + " " + tutor.apellido_m
        lista_tutores.push([nombre_tutor, tutor.cuenta])
      end
      
      return lista_tutores
    end
    helper_method :get_tutores

    def get_valor(valor)
      if valor == "1"
        return "Sí".html_safe
      else valor == "0"
        return "No".html_safe
      end
    end
    helper_method :get_valor
    
    def get_calificaciones(calif)
      @califi = JSON.parse(calif)
      @tabla = "";
      @califi.each do |calificacion|
        @tabla += '<td class="calif">'+calificacion.to_s+'</td>' 
      end
      return @tabla.html_safe
    end
    helper_method :get_calificaciones
    
    def get_promedio(calificaciones)
      @suma = 0
      @calificaciones.each do |calificacion|
        suma += calificacion 
      end
      
      return suma/15
    end
end
