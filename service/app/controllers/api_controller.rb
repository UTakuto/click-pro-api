class ApiController < ApplicationController
  def index
    api_info = {
      name: "Click Pro API",
      version: "1.0.0",
      description: "写真共有アプリケーション用API",
      endpoints: {
        auth: {
          login: {
            method: "POST",
            path: "/login",
            description: "ユーザーログイン",
            parameters: {
              email: "string",
              password: "string"
            }
          }
        },
        users: {
          index: {
            method: "GET",
            path: "/users",
            description: "ユーザー一覧取得"
          },
          show: {
            method: "GET",
            path: "/users/:id",
            description: "ユーザー詳細取得"
          },
          create: {
            method: "POST",
            path: "/users",
            description: "ユーザー作成",
            parameters: {
              name: "string",
              email: "string",
              password: "string"
            }
          }
        },
        photos: {
          index: {
            method: "GET",
            path: "/photos",
            description: "写真一覧取得"
          },
          show: {
            method: "GET",
            path: "/photos/:id",
            description: "写真詳細取得"
          },
          create: {
            method: "POST",
            path: "/photos",
            description: "写真作成（認証必要）",
            parameters: {
              title: "string",
              description: "string",
              image: "file"
            }
          },
          update: {
            method: "PUT/PATCH",
            path: "/photos/:id",
            description: "写真更新（認証必要）"
          },
          destroy: {
            method: "DELETE",
            path: "/photos/:id",
            description: "写真削除（認証必要）"
          }
        }
      },
      authentication: {
        type: "JWT Bearer Token",
        header: "Authorization: Bearer <token>",
        expiration: "20分"
      },
      status: "running",
      timestamp: Time.current
    }
    
    render json: api_info
  end
end
