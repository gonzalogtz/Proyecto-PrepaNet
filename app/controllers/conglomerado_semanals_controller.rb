class ConglomeradoSemanalsController < ApplicationController
  before_action :user_is_logged_in
  before_action :set_conglomerado_semanal, only: [:show, :edit, :update, :destroy]

  # GET /conglomerado_semanals
  # GET /conglomerado_semanals.json
  def index
    if ROL == STR_ROL_COORDINADOR_TUTOR
      @conglomerado_semanals = ConglomeradoSemanal.where(coordinador_tutores: CUENTA)
    elsif ROL == STR_ROL_COORDINADOR_PREPANET || ROL == STR_ROL_COORDINADOR_INFORMATICA
      render "index_coordinador_nacional"
    end
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
    
    info_curso = Curso.where(grupo: @conglomerado_semanal[:curso]).first
    @conglomerado_semanal[:periodo] = info_curso.periodo
    @conglomerado_semanal[:coordinador_tutores] =  info_curso.coordinador_tutores
    @conglomerado_semanal[:campus] =  info_curso.campus

    # Variables calculadas a partir de los reportes semanales
    reportes_semanales = ReporteSemanal.where(tutor: @conglomerado_semanal[:tutor], curso: @conglomerado_semanal[:curso]).order('semana').take(15)
    
    #Se leen las 15 calificaciones de los reportes semanales
    calif_arr = []
    reportes_semanales.each do |reporte|
        calif_arr.push(reporte.calificacion_total)
    end
      
    @conglomerado_semanal[:calificaciones_semanales] = calif_arr.to_json()
    @conglomerado_semanal[:promedio] = calif_arr.sum.fdiv(calif_arr.size)
    @conglomerado_semanal[:horas_desempeno_semanal] =  (@conglomerado_semanal[:promedio]*7.5).ceil
    
    reportes_quincenals_count = ReporteQuincenal.where(tutor: @conglomerado_semanal[:tutor], curso: @conglomerado_semanal[:curso]).count
    alumnos_count = Curso.select("*").where(tutor: @conglomerado_semanal[:tutor], grupo: @conglomerado_semanal[:curso]).joins("INNER JOIN alumno_toma_cursos ON alumno_toma_cursos.curso = cursos.grupo").count
    if reportes_quincenals_count > 0
      @conglomerado_semanal[:horas_reportes] = 15/((6*alumnos_count)/reportes_quincenals_count)
    else
      @conglomerado_semanal[:horas_reportes] = 0
    end
    
    @conglomerado_semanal[:total_horas] =  @conglomerado_semanal[:horas_desempeno_semanal] + @conglomerado_semanal[:horas_reportes]

    respond_to do |format|
      if @conglomerado_semanal.save
        mensaje = "<b>" + get_usuario_name_by_cuenta(@conglomerado_semanal[:coordinador_tutores]) + "</b> ha creado tu reporte <b>final</b> para <b>" + @conglomerado_semanal[:curso] + "</b>"
        Notificacion.crear_notificacion(@conglomerado_semanal[:tutor], mensaje, "/conglomerado_semanals/" + @conglomerado_semanal[:id].to_s)
        format.html { redirect_to conglomerado_semanal_url(@conglomerado_semanal), notice: 'Conglomerado semanal was successfully created.' }
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
        format.html { redirect_to conglomerado_semanal_url(@conglomerado_semanal), notice: 'Conglomerado quincenal was successfully updated.' }
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
    reportes_semanales_count = ReporteSemanal.where(tutor: params[:tutor_id], curso: params[:curso_id]).count
    if reportes_semanales_count < 15
      response = {"tipo_error": 1}
    else
      conglomerado_count = ConglomeradoSemanal.where(tutor: params[:tutor_id], curso: params[:curso_id]).count
      
      #despues checa si ya hay un conglomerado creado
      if conglomerado_count > 0
        response = {"tipo_error": 2}
      end
    end
  
    respond_to do |format|
      format.js {render :json => response}
    end
  end
  
  def get_reportes_by_periodo
    render '_reportes_periodo_nacional', locals: {periodo: params[:periodo_id]}, layout: false
  end
  
  def get_tarjeta_modal
    @tutor = Usuario.where(cuenta: params[:persona_id]).first
    @curso = Curso.where(grupo: params[:curso]).first
    render '_tarjeta_modal', layout: false
  end

  private
    def verify_show_access(conglomerado_semanal)
      if (ROL == STR_ROL_TUTOR && conglomerado_semanal.tutor == CUENTA)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_TUTOR && conglomerado_semanal.coordinador_tutores == CUENTA)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_CAMPUS && conglomerado_semanal.campus == CAMPUS)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_PREPANET)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_INFORMATICA)
        return true
      end
      
      redirect_to "/mainmenu"
    end
    helper_method :verify_show_access
    
    def verify_edit_access(conglomerado_semanal)
      if (ROL == STR_ROL_COORDINADOR_TUTOR && conglomerado_semanal.coordinador_tutores == CUENTA)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_CAMPUS && conglomerado_semanal.campus == CAMPUS)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_PREPANET)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_INFORMATICA)
        return true
      end
      
      redirect_to "/mainmenu"
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
    
    def get_conglomerado_semanals_button_by_tutor_and_curso(tutor_id, curso_id)
      conglomerado_semanals_tutor = ConglomeradoSemanal.where(tutor: tutor_id, curso: curso_id).first
      
      html = ""
      if !conglomerado_semanals_tutor
        html = "<div class='boton_reporte'></div>"
      else
        html = "<div class='boton_reporte boton_reporte_activado' data-link='conglomerado_semanals/" + conglomerado_semanals_tutor.id.to_s + "' ></div>"
      end
      
      return html.html_safe
    end
    helper_method :get_conglomerado_semanals_button_by_tutor_and_curso

    def get_valor(valor)
      if valor == 1
        return "Sí".html_safe
      else valor == 0
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
