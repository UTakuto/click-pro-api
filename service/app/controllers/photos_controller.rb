class PhotosController < ApplicationController
  before_action :authorize_request, only: [:create]

  def index
    photos = Photo.all.includes(:user)
    render json: photos, include: :user
  end

  def show
    photo = Photo.find(params[:id])
    render json: photo, include: :user
  end

  def create
    uploaded_file = params[:image]
    if uploaded_file.nil?
      return render json: { error: "画像がありません" }, status: :bad_request
    end

    begin
      # Cloudinaryへアップロード（presetを指定）
      result = Cloudinary::Uploader.upload(
        uploaded_file,
        upload_preset: ENV['CLOUDINARY_UPLOAD_PRESET']
      )

      # Photoモデルに保存
      photo = @current_user.photos.create!(
        image_url: result['secure_url'],
        title: params[:title],
        description: params[:description]
      )

      render json: photo, status: :created

    rescue => e
      render json: { error: "アップロード失敗: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def update
    if @photo.users != @current_user
      return render json: { error: "権限がありません" }, status: :forbidden
    end

    if @photo.update(title: params[:title], description: params[:description])
      render json: @photo, status: :ok
    else
      render json: { error: @photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @photo.user != @current_user
      return render json: { error: "削除権限がありません" }, status: :forbidden
    end

    @photo.destroy
    render json: { message: "削除しました" }, status: :ok
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "写真が見つかりません" }, status: :not_found
  end
end