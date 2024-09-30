class AuthController < ApplicationController
  include ErrorSerializer  # Incluindo o ErrorSerializer

  def login
    # Validação de parâmetros
    errors = []
    if login_params[:username].blank?
      errors.push('Username is required!')
    end
    if login_params[:password].blank?
      errors.push('Password is required!')
    end

    if errors.present?
      render json: ErrorSerializer.serialize({ authentication: errors }), status: :bad_request
      return
    end

    # Tentativa de encontrar o usuário
    user = User.find_by(username: login_params[:username])

    if user && BCrypt::Password.new(user.password) == login_params[:password]
      render json: { message: 'Successfully Logged', user: user }, status: :ok
    else
      render json: ErrorSerializer.serialize({ authentication: ["Sorry, we couldn't find an account with this username. Please check you're using the right username and try again."] }), status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  rescue ActionController::ParameterMissing
    {}
  end
end
