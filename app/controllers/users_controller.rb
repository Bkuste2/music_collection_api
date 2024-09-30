class UsersController < ApplicationController
  include ErrorSerializer
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    if @user.present?
      render json: @user
    else
      render json: ErrorSerializer.serialize(@user.errors), status: :not_found
    end
  end

  # POST /users
  def create
    begin
      required_params = [:full_name, :username, :password, :role]
      missing_params = required_params.select { |param| params[param].blank? }

      if missing_params.any?
        return render json: { error: "Missing required parameters: #{missing_params.join(', ')}" }, status: :unprocessable_entity
      end

      @user = User.new({
        **user_params,
        password: BCrypt::Password.create(params[:password])
      })

      if @user.save
        render json: @user, status: :created, location: @user
      else
        render json: ErrorSerializer.serialize(@user.errors), status: :unprocessable_entity
      end

    rescue ArgumentError => e
      render json: { error: "Invalid argument: #{e.message}" }, status: :bad_request
    rescue StandardError => e
      render json: { error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
    end
  end

  # PATCH/PUT /users/1
  def update
    @new_pass = BCrypt::Password.create(params[:password]) if params[:password].present?
    update_params = user_params

    # Evita atualizar o username se for o mesmo
    if params[:username].present? && params[:username] == @user.username
      update_params = update_params.except(:username)
    end

    update_params[:password] = @new_pass if @new_pass

    if @user.update(update_params)
      render json: @user, status: :ok
    else
      render json: ErrorSerializer.serialize(@user.errors), status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render json: { message: 'User successfully deleted!' }, status: :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:full_name, :username, :password, :role)
  end
end
