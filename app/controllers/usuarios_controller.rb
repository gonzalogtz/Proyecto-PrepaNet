class UsuariosController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /usuarios
  # GET /usuarios.json
  def index
    @usuarios = Usuario.all
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
  end

  def import
    Usuario.import(params[:file])
    redirect_to root_url, notice: "Usuarios importados."
 end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
  end

  def login
    response = {"tipo_error": 0}
    user = Usuario.where('lower(cuenta) = ?', params[:user].downcase).first
    
    if user != nil
      #credenciales correctas
      if user[:contrasena] == params[:password]
        set_credentials(user.nombres, user.cuenta, user.rol, user.campus)
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

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(user_params)

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to @usuario, notice: 'User was successfully created.' }
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
      if @usuario.update(user_params)
        format.html { redirect_to @usuario, notice: 'User was successfully updated.' }
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
    def set_user
      @usuario = Usuario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_login_params
      params.require(:user).permit(:userid, :password)
    end


    def user_params
      params.require(:user).permit(:userid, :password, :campus, :role, :names, :flname, :slname, :email, :phone, :status)
    end
    
    def set_credentials(user, id, role, campus)
      NOMBRE_USUARIO.replace user
      CUENTA.replace id
      ROL.replace role
      CAMPUS.replace campus
    end
end
