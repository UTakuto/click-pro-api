class ApplicationController < ActionController::API
  before_action :set_current_user

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      # JWTデコード時に有効期限チェックを有効化
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, { verify_expiration: true })[0]
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
      render json: { errors: "認証に失敗しました: #{e.message}" }, status: :unauthorized
    rescue JWT::ExpiredSignature => e
      render json: { errors: "トークンの有効期限が切れています" }, status: :unauthorized
    end
  end

  def set_current_user
    @current_user = nil
  end
end