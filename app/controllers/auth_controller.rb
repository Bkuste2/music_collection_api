class AuthController < ApplicationController
  skip_before_action :authenticate_user

  before_action :set_current_user, only: [:profile]

  def login
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

    user = User.find_by(username: login_params[:username])

    if user && BCrypt::Password.new(user.password) == login_params[:password]
      payload = { user_id: user.id }
      token = JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
      render json: { access_token: token }, status: :ok
    else
      render json: ErrorSerializer.serialize({ authentication: ["Sorry, we couldn't find an account with this username. Please check you're using the right username and try again."] }), status: :unauthorized
    end
  end

  def profile
    if @current_user.present?
      render json: @current_user, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def set_current_user
    begin
      token = request.headers['Authorization']&.split(' ')&.last

      if token
        decoded_token = JWT.decode(token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' })
        user_id = decoded_token[0]['user_id']
        @current_user = User.find_by(id: user_id)
      end

      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user

    rescue JWT::ExpiredSignature
      render json: { error: 'Token expired' }, status: :unauthorized
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  def login_params
    params.permit(:username, :password)
  rescue ActionController::ParameterMissing
    {}
  end
end
