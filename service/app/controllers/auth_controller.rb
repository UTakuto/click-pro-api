# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
      render json: { token: token, user: user }
    else
      render json: { error: '認証に失敗しました' }, status: :unauthorized
    end
  end
end