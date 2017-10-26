class ReporteQuincenalsController < ApplicationController
	before_action :user_is_logged_in
  before_action :set_reporte_quincenal, only: [:show, :edit, :update, :destroy]

  # GET /reporte_quincenals
  # GET /reporte_quincenals.json
  def index
    @reporte_quincenals = ReporteQuincenal.all.order('fecha_correspondiente desc, alumno')
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
        format.html { redirect_to reporte_quincenals_path, notice: 'Reporte quincenal was successfully created.' }
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
        format.html { redirect_to reporte_quincenals_path, notice: 'Reporte quincenal was successfully updated.' }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_reporte_quincenal
      @reporte_quincenal = ReporteQuincenal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reporte_quincenal_params
      params.require(:reporte_quincenal).permit(:alumno, :curso, :estatus, :localizado, :comentarios, :fecha_correspondiente)
    end
    
    ALUMNOS  = [["Gonzalo Gutierrez", 1], ["David Valles", 2], ["Armando Galvan", 3], ["Adriana Montecarlo Ramirez", 4]]
    
    def get_estatus_tag(estatus)
      if estatus == '0'
        return "<td class='texto_negativo'>Inactivo</td>".html_safe
      elsif estatus == '1'
        return "<td class='texto_amarillo'>Parcialmente activo</td>".html_safe
      else estatus == '2'
        return "<td class='texto_positivo'>Activo</td>".html_safe
      end
    end
    helper_method :get_estatus_tag
    
    def get_localizado_tag(localizado)
      if localizado == '0'
        return "<td class='texto_negativo'>No</td>".html_safe
      elsif localizado == '1'
        return "<td class='texto_positivo'>Sí</td>".html_safe
      end
    end
    helper_method :get_localizado_tag
end