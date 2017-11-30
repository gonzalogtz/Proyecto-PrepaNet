class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]

  # GET /usuarios
  # GET /usuarios.json
  def index
    @usuarios = Usuario.all.order('cuenta')
    @periodo_activo = get_periodo_activo()
  end

  def agregar
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
  end

  def import
    summary = Usuario.import(params[:file])
    render 'summary_import', locals: {summary: summary}
 end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
    @periodo_activo = get_periodo_activo()
  end

  # GET /usuarios/1/edit
  def edit
  end

  def login
    response = {"tipo_error": 0}
    user = Usuario.where('upper(cuenta) = ?', params[:user].upcase).first
    
    if user != nil
      #credenciales correctas
      if user[:contrasena] == params[:password] 
        #usuario correcto pero de periodo antiguo, coordinador nacional o de informatica el periodo no importa
        if (user.rol != STR_ROL_COORDINADOR_PREPANET && user.rol != STR_ROL_COORDINADOR_INFORMATICA) && user.periodo != get_periodo_activo()
            response = {"tipo_error": 3}
        else
          set_credentials(user.nombres, user.cuenta, user.rol, user.campus)
        end
      #contraseña incorrecta
      else
        response = {"tipo_error": 1}
      end
    #el usuario no existe
    else
      response = {"tipo_error": 2}
    end
    
      respond_to do |format|
        format.js {render :json => response}
      end
  end

  def logout
    set_credentials("", "", "", "")
  end
  
  def valida_cuenta_disponible
    user = Usuario.where('upper(cuenta) = ?', params[:cuenta].upcase).first
    
    if user
      response = {"disponible": 0}
    else
      response = {"disponible": 1}
    end

    respond_to do |format|
      format.js {render :json => response}
    end
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(usuario_params)
    @usuario[:periodo] = get_periodo_activo()
    @usuario[:cuenta] = @usuario[:cuenta].upcase

    respond_to do |format|
      if @usuario.save
        format.html { render :show}
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { render :show}
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario.destroy
    respond_to do |format|
      format.html { redirect_to usuarios_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
    end
    
    def user_coordinador_informatica()
      if (ROL != STR_ROL_COORDINADOR_INFORMATICA)
        redirect_to "/menuerror"
      end
    end
    helper_method :user_coordinador_informatica

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_login_params
      params.require(:usuario).permit(:cuenta, :contrasena)
    end


    def usuario_params
      params.require(:usuario).permit(:cuenta, :nomina_matricula, :contrasena, :campus, :rol, :nombres, :apellido_p, :apellido_m, :correo, :telefono, :periodo)
    end
    
    def set_credentials(user, id, role, campus)
      NOMBRE_USUARIO.replace user
      CUENTA.replace id
      ROL.replace role
      CAMPUS.replace campus
    end
end
