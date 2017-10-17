class ConglomeradoQuincenalsController < ApplicationController
  before_action :set_conglomerado_quincenal, only: [:show, :edit, :update, :destroy]

  # GET /conglomerado_quincenals
  # GET /conglomerado_quincenals.json
  def index
    @conglomerado_quincenals = ConglomeradoQuincenal.all
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
    @reportes_semanales = ReporteSemanal.all.order('created_at desc').take(15)
    @conglomerado_quincenal[:tutor] = "Tutor generico"
    calif_arr = [90,90,90,90,90,90,90,90,90,90,90,90,90,90,90]
    @conglomerado_quincenal[:calificaciones] = calif_arr.to_json()
    @conglomerado_quincenal[:promedio] = calif_arr.sum.fdiv(calif_arr.size)
    @conglomerado_quincenal[:horas_desemp] =  @conglomerado_quincenal[:promedio]*0.75
    #alumnos acabaron
    #alumnos aprobaron
    #alumnos concluyeron
    @conglomerado_quincenal[:horas_reportes] = 15
    @conglomerado_quincenal[:total_horas] =  @conglomerado_quincenal[:horas_desemp] + @conglomerado_quincenal[:horas_reportes]
    #total_horas_sugerido

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conglomerado_quincenal
      @conglomerado_quincenal = ConglomeradoQuincenal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conglomerado_quincenal_params
      params.require(:conglomerado_quincenal).permit(:materia, :tutor, :invito, :rparcial, :rfinal, :resumen, :cierre, :reingresar, :recomendacion)
    end
    
    def get_calificaciones()
      return '<td class="calif">90</td>
              <td class="calif">88</td>
              <td class="calif">90</td>
              <td class="calif">90</td>
              <td class="calif">91</td>
              <td class="calif">96</td>
              <td class="calif">91</td>
              <td class="calif">95</td>
              <td class="calif">92</td>
              <td class="calif">95</td>
              <td class="calif">92</td>
              <td class="calif">93</td>
              <td class="calif">96</td>
              <td class="calif">94</td>
              <td class="calif">92</td>
              <td id="promedio">90</td>'.html_safe
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
