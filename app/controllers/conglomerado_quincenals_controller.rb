class ConglomeradoQuincenalsController < ApplicationController
  before_action :set_conglomerado_quincenal, only: [:show, :edit, :update, :destroy]

  # GET /conglomerado_quincenals
  # GET /conglomerado_quincenals.json
  def index
    @conglomerado_quincenals = ConglomeradoQuincenal.where(coordinador_tutores: USER_ID)
  end

  # GET /conglomerado_quincenals/1
  # GET /conglomerado_quincenals/1.json
  def show
  end

  # GET /conglomerado_quincenals/new
  def new
    @conglomerado_quincenal = ConglomeradoQuincenal.new
  end

  # GET /conglomerado_quincenals/1/edit
  def edit
  end

  # POST /conglomerado_quincenals
  # POST /conglomerado_quincenals.json
  def create
    @conglomerado_quincenal = ConglomeradoQuincenal.new(conglomerado_quincenal_params)
    @conglomerado_quincenal[:coordinador_tutores] =  USER_ID

    # Variables calculadas a partir de los reportes semanales
    reportes_semanales = ReporteSemanal.where(tutor: @conglomerado_quincenal[:tutor], coordinador_tutores: USER_ID).order('semana').take(15)
    
    #Se leen las 15 calificaciones de los reportes semanales
    calif_arr = []
    reportes_semanales.each do |reporte|
        calif_arr.push(reporte.total)
    end
      
    @conglomerado_quincenal[:calificaciones] = calif_arr.to_json()
    @conglomerado_quincenal[:promedio] = calif_arr.sum.fdiv(calif_arr.size)
    @conglomerado_quincenal[:horas_desemp] =  @conglomerado_quincenal[:promedio]*7.5
    @conglomerado_quincenal[:horas_reportes] = 15
    @conglomerado_quincenal[:total_horas] =  @conglomerado_quincenal[:horas_desemp] + @conglomerado_quincenal[:horas_reportes]

    respond_to do |format|
      if @conglomerado_quincenal.save
        format.html { redirect_to conglomerado_quincenals_path, notice: 'Conglomerado quincenal was successfully created.' }
        format.json { render :show, status: :created, location: @conglomerado_quincenal }
      else
        format.html { render :new }
        format.json { render json: @conglomerado_quincenal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conglomerado_quincenals/1
  # PATCH/PUT /conglomerado_quincenals/1.json
  def update
    respond_to do |format|
      if @conglomerado_quincenal.update(conglomerado_quincenal_params)
        format.html { redirect_to conglomerado_quincenals_path, notice: 'Conglomerado quincenal was successfully updated.' }
        format.json { render :show, status: :ok, location: @conglomerado_quincenal }
      else
        format.html { render :edit }
        format.json { render json: @conglomerado_quincenal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conglomerado_quincenals/1
  # DELETE /conglomerado_quincenals/1.json
  def destroy
    @conglomerado_quincenal.destroy
    respond_to do |format|
      format.html { redirect_to conglomerado_quincenals_url, notice: 'Conglomerado quincenal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # POST conglomerado_quincenals/get_semanales
  def get_semanales_count
    response = {"tipo_error": 0}
    
    #primero checa si no hay 15 reportes semanales todavia
    reportes_semanales = ReporteSemanal.where(tutor: params[:tutor_id], coordinador_tutores: USER_ID).take(15)
    if reportes_semanales.count < 15
      response = {"tipo_error": 1}
    else
      conglomerado = ConglomeradoQuincenal.where(tutor: params[:tutor_id], coordinador_tutores: USER_ID)
      
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
    # Use callbacks to share common setup or constraints between actions.
    def set_conglomerado_quincenal
      @conglomerado_quincenal = ConglomeradoQuincenal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conglomerado_quincenal_params
      params.require(:conglomerado_quincenal).permit(:materia, :tutor, :invito, :rparcial, :rfinal, :resumen, :cierre, :reingresar, 
      :recomendacion, :alumnos_acabaron, :alumnos_aprobaron, :alumnos_final_concluyeron, :total_horas_sugerido)
    end

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
    
    TUTORES  = [["Gonzalo Gutierrez", 1], ["David Valles", 2], ["Armando Galvan", 3], ["Adriana Montecarlo Ramirez", 4]]
    MATERIAS  = [["Matematicas I", 1], ["Quimica I", 2]]
end
