# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  # トークンの有効期限（20分）
  TOKEN_EXPIRATION_TIME = 1.minutes

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      # 20分の有効期限を設定
      payload = {
        user_id: user.id,
        exp: (Time.current + TOKEN_EXPIRATION_TIME).to_i
      }
      token = JWT.encode(payload, Rails.application.secret_key_base)
      render json: { token: token, user: user }
    else
      render json: { error: '認証に失敗しました' }, status: :unauthorized
    end
  end
end