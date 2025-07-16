# Click Pro PAI

## 概要

2 年前期のクリエイティブワークの作品です。
プロのカメラマンを目指す人たちや、写真の技術向上を目指し写真の撮影方法を学びたいと考えている人たち向け。

## 📦 使用技術

-   **Ruby on Rails**
-   **MySQL**
-   **Docker / Docker Compose**
-   **Cloudinary（画像保存用）**

---

## 📁 ディレクトリ構成

```
.
├── Dockerfile             # Rails用のDockerfile
├── compose.yml            # Docker Compose構成
├── .env                   # 環境変数
├── Gemfile                # Gem管理
├── Gemfile.lock
├── service/               # Railsアプリ本体（APIモードで生成）
├── db_data/               # MySQLの永続化ボリューム
└── README.md
```

---

## 🛠 セットアップ手順

### 1. リポジトリをクローン

```bash
git clone https://github.com/UTakuto/click-pro-api.git
cd click-pro-api
```

### 2. service ディレクトリ内で Rails API アプリを作成（初回のみ）

```bash
docker compose run web rails new . --api --database=mysql
```

### 3. Gem をインストール

```bash
docker compose run web bundle install
```

### 4. データベース設定の確認

`.env` または `config/database.yml` を編集して、`host: db` になっていることを確認。

### 5. DB 作成とマイグレーション

```bash
docker compose run web rails db:create
docker compose run web rails db:migrate
```

### 6. サーバ起動

```bash
docker compose up --build
```

---

## 🌐 アクセス

-   API エンドポイント: [http://localhost:3004](http://localhost:3004)

---

## 機能一覧 / API 仕様

| エンドポイント | メソッド | 概要                 | 認証               |
| -------------- | -------- | -------------------- | ------------------ |
| /users         | POST     | ユーザー新規登録     | 不要               |
| /login         | POST     | ログイン（JWT 発行） | 不要               |
| /users/:id     | GET      | ユーザー情報取得     | 不要               |
| /login         | POST     | ログイン（JWT 発行） | 不要               |
| /photos        | GET      | 投稿一覧取得         | 不要               |
| /photos/:id    | GET      | 投稿詳細取得         | 不要               |
| /photos        | POST     | 新規投稿             | 必要               |
| /photos/:id    | PATCH    | 投稿編集             | 必要（投稿者のみ） |
| /photos/:id    | DELETE   | 投稿削除             | 必要（投稿者のみ） |

## リクエスト・レスポンス一覧

### /login リクエスト

**概要**
ログイン成功時、JWT トークンを返却します。
このトークンは、認証が必要な API（投稿作成・編集・削除、自分のユーザー情報取得 など）で Authorization ヘッダーに付与して使用します。
**POST /login**

```
{
    "email": "test@example.com",
    "password": "password"
}
```

**/login レスポンス**
**ログイン成功時**

```
{
    "token": "xxxxx.yyyyy.zzzzz",
    "user": {
        "id": 1,
        "name": "Test User",
        "email": "test@example.com"
    }
}
```

**以降、リクエスト送る時 Headers に Token を入れてください**

```
Authorization: Bearer xxxxx.yyyyy.zzzzz
```
