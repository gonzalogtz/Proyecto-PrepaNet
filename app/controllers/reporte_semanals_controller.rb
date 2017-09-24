class ReporteSemanalsController < ApplicationController
  before_action :set_reporte_semanal, only: [:show, :edit, :update, :destroy]

  # GET /reporte_semanals
  # GET /reporte_semanals.json
  def index
    @reporte_semanals = ReporteSemanal.all
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

    respond_to do |format|
      if @reporte_semanal.save
        format.html { redirect_to @reporte_semanal, notice: 'Reporte semanal was successfully created.' }
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
      if @reporte_semanal.update(reporte_semanal_params)
        format.html { redirect_to @reporte_semanal, notice: 'Reporte semanal was successfully updated.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reporte_semanal
      @reporte_semanal = ReporteSemanal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reporte_semanal_params
      params.require(:reporte_semanal).permit(:tutor, :califPlazo, :califRubrica, :retro, :responde, :errores, :comentarios)
    end
end
