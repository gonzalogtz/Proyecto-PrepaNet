class ReporteSemanalsController < ApplicationController
	before_action :user_is_logged_in
  before_action :set_reporte_semanal, only: [:show, :edit, :update, :destroy]

  # GET /reporte_semanals
  # GET /reporte_semanals.json
  def index
    if ROL == STR_ROL_TUTOR
      render "index_tutor"
    elsif ROL == STR_ROL_COORDINADOR_PREPANET || ROL == STR_ROL_COORDINADOR_INFORMATICA
      render "index_coordinador_nacional"
    end
  end

  # GET /reporte_semanals/1
  # GET /reporte_semanals/1.json
  def show
  end

  # GET /reporte_semanals/new
  def new
    @reporte_semanal = ReporteSemanal.new
  end

  # GET /reporte_semanals/1/edit
  def edit
  end

  # POST /reporte_semanals
  # POST /reporte_semanals.json
  def create
    @reporte_semanal = ReporteSemanal.new(reporte_semanal_params)
    
    info_curso = Curso.where(grupo: @reporte_semanal[:curso]).first
    @reporte_semanal[:coordinador_tutores] = info_curso.coordinador_tutores
    @reporte_semanal[:periodo] = info_curso.periodo
    @reporte_semanal[:campus] = info_curso.campus
    
    @reporte_semanal[:calificacion_total] = get_calif_total(@reporte_semanal)
    
    respond_to do |format|
      if @reporte_semanal.save
        mensaje = "<b>" + get_usuario_name_by_cuenta(@reporte_semanal[:coordinador_tutores]) + "</b> ha creado tu reporte de la semana <b>" + @reporte_semanal[:semana].to_s + "</b> para <b>" + @reporte_semanal[:curso] + "</b>"
        Notificacion.crear_notificacion(@reporte_semanal[:tutor], mensaje, "/reporte_semanals/" + @reporte_semanal[:id].to_s)
        format.html { redirect_to reporte_semanals_path, notice: 'Reporte semanal was successfully created.' }
        format.json { render :show, status: :created, location: @reporte_semanal }
      else
        format.html { render :new }
        format.json { render json: @reporte_semanal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reporte_semanals/1
  # PATCH/PUT /reporte_semanals/1.json
  def update
    respond_to do |format|
      if(@reporte_semanal.update(reporte_semanal_params) && @reporte_semanal.update_attribute(:calificacion_total, get_calif_total(@reporte_semanal)))
        format.html { redirect_to reporte_semanal_url(@reporte_semanal), notice: 'Reporte semanal was successfully updated.' }
        format.json { render :show, status: :ok, location: @reporte_semanal }
      else
        format.html { render :edit }
        format.json { render json: @reporte_semanal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reporte_semanals/1
  # DELETE /reporte_semanals/1.json
  def destroy
    @reporte_semanal.destroy
    respond_to do |format|
      format.html { redirect_to reporte_semanals_url, notice: 'Reporte semanal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def valida_reporte_tutor_curso_semana
    reportes_semanales_count = ReporteSemanal.where(tutor: params[:tutor_id], curso: params[:curso_id], semana: params[:semana]).count

    respond_to do |format|
      format.js {render :json => {"semanal_count": reportes_semanales_count}}
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
    def verify_show_access(reporte_semanal)
      if (ROL == STR_ROL_TUTOR && reporte_semanal.tutor == CUENTA)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_TUTOR && reporte_semanal.coordinador_tutores == CUENTA)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_CAMPUS && reporte_semanal.campus == CAMPUS)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_PREPANET)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_INFORMATICA)
        return true
      end
        
      redirect_to "/menuerror"
    end
    helper_method :verify_show_access
    
    def verify_edit_access(reporte_semanal)
      if (ROL == STR_ROL_COORDINADOR_TUTOR && reporte_semanal.coordinador_tutores == CUENTA)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_CAMPUS && reporte_semanal.campus == CAMPUS)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_PREPANET)
        return true
      elsif (ROL == STR_ROL_COORDINADOR_INFORMATICA)
        return true
      end
        
      redirect_to "/menuerror"
    end
    helper_method :verify_edit_access
    
    def read_reporte_semanals_by_tutor_and_curso(tutor_id, curso_id)
      @reporte_semanals_tutor = ReporteSemanal.where(tutor: tutor_id, curso: curso_id).order('semana')
    end
    helper_method :read_reporte_semanals_by_tutor_and_curso
    
    def get_reporte_semanals_by_tutor_and_curso()
      return @reporte_semanals_tutor
    end
    helper_method :get_reporte_semanals_by_tutor_and_curso
    
    def get_reporte_semanals_by_semana(num_semana)
      reporte_semanal = @reporte_semanals_tutor.where(semana: num_semana).first
      
      html = ""
      if !reporte_semanal
        html = "<div class='boton_reporte'>" + num_semana.to_s + "</div>"
      else
        html = "<div class='boton_reporte boton_reporte_activado' data-link='reporte_semanals/" + reporte_semanal.id.to_s + "' 
        data-toggle='tooltip' title='" + reporte_semanal.calificacion_total.to_s + "/10' data-placement='bottom'>" + num_semana.to_s + "</div>"
      end
      
      return html.html_safe
    end
    helper_method :get_reporte_semanals_by_semana
    
    def get_botones_reportes_semanales_carousel(num_semana)
      reporte_semanal = @reporte_semanals_tutor.where(semana: num_semana).first
      
      html = ""
      if !reporte_semanal
        html = "<div class='boton_carousel_reporte'>" + num_semana.to_s + "</div>"
      else
        html = "<div class='boton_carousel_reporte boton_carousel_reporte_activado' data-link='"+ reporte_semanal.id.to_s + "' 
        data-toggle='tooltip' title='" + reporte_semanal.calificacion_total.to_s + "/10' data-placement='top'>" + num_semana.to_s + "</div>"
      end
      
      return html.html_safe
    end
    helper_method :get_botones_reportes_semanales_carousel
    
    def get_conglomerado_semanals_button_by_tutor_and_curso(tutor_id, curso_id)
      @conglomerado_semanals_tutor = ConglomeradoSemanal.where(tutor: tutor_id, curso: curso_id).first
      
      html = ""
      if !@conglomerado_semanals_tutor
        html = "<div class='boton_carousel_reporte' data-toggle='tooltip' title='Promedio actual: " + get_promedio_actual(tutor_id, curso_id).to_s + "/10' data-placement='top'>F</div>"
      else
        html = "<div class='boton_carousel_reporte boton_carousel_reporte_activado' data-link='cong_" + @conglomerado_semanals_tutor.id.to_s + "' 
        data-toggle='tooltip' title='" + @conglomerado_semanals_tutor.promedio.to_s + "/10' data-placement='top'>F</div>"
      end
      
      return html.html_safe
    end
    helper_method :get_conglomerado_semanals_button_by_tutor_and_curso
    
    def get_promedio_actual(tutor_id, curso_id)
      reportes_semanales = ReporteSemanal.where(tutor: tutor_id, curso: curso_id)
      
      calif_arr = []
      reportes_semanales.each do |reporte|
          calif_arr.push(reporte.calificacion_total)
      end
      
      if (calif_arr.length > 0)
        promedio = calif_arr.sum.fdiv(calif_arr.size)
      else
        promedio = 0
      end
      
      return promedio.ceil
    end
    
    def get_conglomerado_semanals()
      return @conglomerado_semanals_tutor
    end
    helper_method :get_conglomerado_semanals
    
    # Use callbacks to share common setup or constraints between actions.
    def set_reporte_semanal
      @reporte_semanal = ReporteSemanal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reporte_semanal_params
      params.require(:reporte_semanal).permit(:tutor, :curso, :semana, :califica_en_plazo, :califica_con_rubrica, :da_retroalimentacion, :responde_mensajes, 
      :errores_ortografia, :comentarios)
    end

    # Hace la sumatoria de puntos de la rubrica para conseguir una calificacion total
    def get_calif_total(reporte)
      return reporte.califica_en_plazo + reporte.califica_con_rubrica + reporte.da_retroalimentacion + reporte.responde_mensajes + reporte.errores_ortografia
    end
    helper_method :get_calif_total
end