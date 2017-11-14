class ReporteQuincenalsController < ApplicationController
  before_action :user_is_logged_in
  before_action :set_reporte_quincenal, only: [:show, :edit, :update, :destroy]

  # GET /reporte_quincenals
  # GET /reporte_quincenals.json
  def index
    if ROL == STR_ROL_COORDINADOR_TUTOR || ROL == STR_ROL_COORDINADOR_CAMPUS
      render "index_coordinador_tutor"
    end
  end

  # GET /reporte_quincenals/1
  # GET /reporte_quincenals/1.json
  def show
  end

  # GET /reporte_quincenals/new
  def new
    @reporte_quincenal = ReporteQuincenal.new
  end

  # GET /reporte_quincenals/1/edit
  def edit
  end

  # POST /reporte_quincenals
  # POST /reporte_quincenals.json
  def create
    @reporte_quincenal = ReporteQuincenal.new(reporte_quincenal_params)
    @reporte_quincenal[:tutor] = CUENTA
    @reporte_quincenal[:fecha_correspondiente] = Date.today

    respond_to do |format|
      if @reporte_quincenal.save
        format.html { redirect_to reporte_quincenal_url(@reporte_quincenal), notice: 'Reporte quincenal was successfully created.' }
        format.json { render :show, status: :created, location: @reporte_quincenal }
      else
        format.html { render :new }
        format.json { render json: @reporte_quincenal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reporte_quincenals/1
  # PATCH/PUT /reporte_quincenals/1.json
  def update
    respond_to do |format|
      if @reporte_quincenal.update(reporte_quincenal_params)
        format.html { redirect_to redirect_to reporte_quincenal_url(@reporte_quincenal), notice: 'Reporte quincenal was successfully updated.' }
        format.json { render :show, status: :ok, location: @reporte_quincenal }
      else
        format.html { render :edit }
        format.json { render json: @reporte_quincenal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reporte_quincenals/1
  # DELETE /reporte_quincenals/1.json
  def destroy
    @reporte_quincenal.destroy
    respond_to do |format|
      format.html { redirect_to reporte_quincenals_url, notice: 'Reporte quincenal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def verify_show_access(reporte_quincenal)
      #el reporte lo puede ver el tutor
      if (reporte_quincenal.tutor != CUENTA)
        coordinador_tutor = UsuarioCoordinaUsuario.where(usuario: reporte_quincenal.tutor).first
        
        #el coordinador de tutores tambien puede ver los reportes
        if (coordinador_tutor.coordinador != CUENTA)
          redirect_to "/mainmenu"
        end
      end
    end
    helper_method :verify_show_access
    
    def get_reporte_quincenals_by_alumno_and_curso(alumno_id, curso_id)
      @reporte_quincenals_alumnos = ReporteQuincenal.where(alumno: alumno_id, curso: curso_id).order('fecha_correspondiente')
    end
    helper_method :get_reporte_quincenals_by_alumno_and_curso
    
    def get_reporte_quincenals_buttons
      html = ""
      i = 1
      
      if @reporte_quincenals_alumnos.present?
        @reporte_quincenals_alumnos.each do |reporte|
          html += "<div class='boton_reporte boton_reporte_activado' data-link='reporte_quincenals/" + reporte.id.to_s + "' 
          data-toggle='tooltip' title='" + reporte.fecha_correspondiente.strftime(ApplicationController::FORMATO_FECHA) + "' data-placement='bottom'>" + i.to_s + "</div>"
          i += 1
        end
      else
        html += "<div class='no_reportes footer_no_reportes'>No se tienen reportes para este alumno</div>"
      end
      
      return html.html_safe
    end
    helper_method :get_reporte_quincenals_buttons
    
    def get_ultimo_estatus
      if @reporte_quincenals_alumnos.present?
        #last corresponde al reporte mas reciente
        return get_estatus_tag(@reporte_quincenals_alumnos.last[:estatus])
      else
        return "<span data-existencia='0' class='no_reportes'>No existe información</span>".html_safe
      end
    end
    helper_method :get_ultimo_estatus
    
    def get_ultimo_localizado
      if @reporte_quincenals_alumnos.present?
        #last corresponde al reporte mas reciente
        return get_localizado_tag(@reporte_quincenals_alumnos.last[:localizado])
      else
        return "<span class='no_reportes'>No existe información</span>".html_safe
      end 
    end
    helper_method :get_ultimo_localizado
    
    # Use callbacks to share common setup or constraints between actions.
    def set_reporte_quincenal
      @reporte_quincenal = ReporteQuincenal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reporte_quincenal_params
      params.require(:reporte_quincenal).permit(:alumno, :curso, :estatus, :localizado, :comentarios, :fecha_correspondiente)
    end
    
    def get_estatus_tag(estatus)
      if estatus == 0
        tag = "<span data-existencia='1' data-estatus='0' class='texto_negativo'>Inactivo</span>"
      elsif estatus == 1
        tag = "<span data-existencia='1' data-estatus='1' class='texto_amarillo'>Parcialmente activo</span>"
      elsif estatus == 2
        tag = "<span data-existencia='1' data-estatus='2' class='texto_positivo'>Activo</span>"
      end
      
      return tag.html_safe
    end
    helper_method :get_estatus_tag
    
    def get_localizado_tag(localizado)
      if localizado == 0
        tag = "<span data-localizado='0' class='texto_negativo'>No</span>"
      elsif localizado == 1
        tag = "<span data-localizado='1' class='texto_positivo'>Sí</span>"
      end
      
      return tag.html_safe
    end
    helper_method :get_localizado_tag
end