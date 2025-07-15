class PhotosController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :set_photo, only: [:show, :update, :destroy]

  def index
    photos = Photo.all.includes(:user)
    render json: photos, include:{ user:{ only: [:id, :name, :email] }}
  end

  def show
    photo = Photo.find(params[:id])
    render json: photo.as_json(include:{ user:{ only: [:id, :name, :email] }})
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

      render json: photo.as_json(include: { user: { only: [:id, :name, :email] } }), status: :created

    rescue => e
      render json: { error: "アップロード失敗: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def update
    if @photo.user != @current_user
      return render json: { error: "権限がありません" }, status: :forbidden
    end

    image_url = @photo.image_url

    if params[:image].present?
      result = Cloudinary::Uploader.upload(
        params[:image],
        upload_preset: ENV['CLOUDINARY_UPLOAD_PRESET']
      )
      image_url = result['secure_url']
    end

    if @photo.update(params.permit(:title, :image, :description))
      render json: @photo.as_json(include: { user: { only: [:id, :name, :email] } }), status: :ok
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