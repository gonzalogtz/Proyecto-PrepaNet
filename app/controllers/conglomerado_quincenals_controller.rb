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

    respond_to do |format|
      if @conglomerado_quincenal.save
        format.html { redirect_to @conglomerado_quincenal, notice: 'Conglomerado quincenal was successfully created.' }
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
        format.html { redirect_to @conglomerado_quincenal, notice: 'Conglomerado quincenal was successfully updated.' }
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
end
