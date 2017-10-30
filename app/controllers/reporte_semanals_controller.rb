class ReporteSemanalsController < ApplicationController
	before_action :user_is_logged_in
  before_action :set_reporte_semanal, only: [:show, :edit, :update, :destroy]

  # GET /reporte_semanals
  # GET /reporte_semanals.json
  def index
    @reporte_semanals = ReporteSemanal.where(coordinador_tutores: CUENTA)
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
    @reporte_semanal[:calificacion_total] = get_calif_total(@reporte_semanal)
    @reporte_semanal[:coordinador_tutores] = CUENTA
    
    respond_to do |format|
      if @reporte_semanal.save
        notificacion = Notificacion.new(usuario: @reporte_semanal[:tutor], mensaje: "Tu coordinador de tutores ha creado tu reporte correspondiente a la semana " + @reporte_semanal[:semana].to_s, liga: "/reporte_semanals/" + @reporte_semanal[:id].to_s)
        notificacion.save
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
      if(@reporte_semanal.update(reporte_semanal_params) && @reporte_semanal.update_attribute(:total, get_calif_total(@reporte_semanal)))
        format.html { redirect_to reporte_semanals_path, notice: 'Reporte semanal was successfully updated.' }
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
  
  def valida_tutor_semana
    reportes_semanal = ReporteSemanal.where(tutor: params[:tutor_id], semana: params[:semana], coordinador_tutores: CUENTA)

    respond_to do |format|
      format.js {render :json => {"semanal_count": reportes_semanal.count}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reporte_semanal
      @reporte_semanal = ReporteSemanal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reporte_semanal_params
      params.require(:reporte_semanal).permit(:tutor, :semana, :califica_en_plazo, :califica_con_rubrica, :da_retroalimentacion, :responde_mensajes, 
      :errores_ortografia, :comentarios)
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

    # Hace la sumatoria de puntos de la rubrica para conseguir una calificacion total
    def get_calif_total(reporte)
      return reporte.califica_en_plazo + reporte.califica_con_rubrica + reporte.da_retroalimentacion 
      + reporte.responde_mensajes + reporte.errores_ortografia
    end
    helper_method :get_calif_total
    
    def get_reportes_colapsados
      reportes_semanales = ReporteSemanal.where(coordinador_tutores: CUENTA)
      html_list = ""
      i = 0
      
      tutores = get_tutores
      tutores.each do |tutor|
        reportes_tutor = reportes_semanales.where(tutor: tutor[1]).order('semana')
        html_list += "<tr id='" + i.to_s +  "' class='pickHover tutor_header'>
                        <td>" + tutor[0] + "</td>
                        <td>" + reportes_tutor.count.to_s + "/15</td>
                      </tr>"
                      
        html_list += "<tr class='tutor_content" + i.to_s + "' style='display: none;'>
                        <td colspan='2'>
                          <div class='table-resposive'>
                            <table class='table table-striped txtCenter'>
                              <thead>
                                <tr>
                                  <th class='txtCenter'>Semana</th>
                                  <th class='txtCenter'>Tutor</th>
                                  <th class='txtCenter'>Calificación</th>
                                </tr>
                              </thead>
                              <tbody>"
                              
        reportes_tutor.each do |reporte|
          html_list += "<tr class='pickHover reporte_row' data-link='reporte_semanals/" + reporte.id.to_s + "'>"
          html_list += "<td>" + reporte.semana.to_s + "</td>"
          html_list += "<td>" + get_usuario_name_by_id(reporte.tutor) + "</td>"
          html_list += "<td>" + reporte.calificacion_total.to_s + "</td>"
          html_list += "</tr>"
        end
        
        html_list += "</tbody>
                      </table>
                      </div>
                      </td>
                      </tr>"
        
        i += 1
      end
      
      return html_list.html_safe
    end
    helper_method :get_reportes_colapsados
end