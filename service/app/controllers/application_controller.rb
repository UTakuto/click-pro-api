class ApplicationController < ActionController::API
  before_action :set_current_user

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
      render json: { errors: "認証に失敗しました: #{e.message}" }, status: :unauthorized
    end
  end

  def set_current_user
    @current_user = nil
  end
end