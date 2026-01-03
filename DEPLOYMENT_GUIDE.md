# My ROUTINE デプロイメントガイド

このガイドでは、My ROUTINEアプリを公開するための手順を、初心者の方にもわかりやすく説明します。

---

## 📋 目次

1. [全体の流れ](#全体の流れ)
2. [Step 1: GitHubリポジトリの準備](#step-1-githubリポジトリの準備)
3. [Step 2: Supabaseのセットアップ](#step-2-supabaseのセットアップ)
4. [Step 3: アプリとSupabaseの連携](#step-3-アプリとsupabaseの連携)
5. [Step 4: Vercelへのデプロイ](#step-4-vercelへのデプロイ)
6. [トラブルシューティング](#トラブルシューティング)

---

## 全体の流れ

```
┌─────────────────────────────────────────────────────────┐
│  作業の流れ（推奨順序）                                    │
└─────────────────────────────────────────────────────────┘

  1️⃣ GitHubリポジトリの準備
     ↓
     - GitHubアカウント作成
     - リポジトリ作成
     - コードをプッシュ
     📝 理由: VercelはGitHubと連携してデプロイするため、
             最初にGitHubにコードを保存する必要があります

  2️⃣ Supabaseのセットアップ
     ↓
     - Supabaseアカウント作成
     - プロジェクト作成
     - データベーステーブル作成
     - APIキー取得
     📝 理由: データベースの準備ができてから、
             アプリのコードを修正する方が効率的です

  3️⃣ アプリとSupabaseの連携
     ↓
     - index.htmlを修正（Supabase SDK追加）
     - LocalStorage → Supabase移行
     - GitHubにプッシュ
     📝 理由: データベースと連携してからデプロイすることで、
             公開時には完全に動作する状態になります

  4️⃣ Vercelへのデプロイ
     ↓
     - Vercelアカウント作成
     - GitHubリポジトリと連携
     - 環境変数設定
     - デプロイ実行
     📝 理由: 最後にデプロイすることで、完成したアプリを
             すぐに世界中からアクセス可能にできます

```

---

## Step 1: GitHubリポジトリの準備

### 🎯 目標
コードをGitHubに保存して、バージョン管理とデプロイの準備をします。

### 📝 必要なもの
- GitHubアカウント（無料）
- インターネット接続

### 🔧 手順

#### 1-1. GitHubアカウントの作成

1. **GitHubにアクセス**
   - URL: https://github.com/
   - 右上の「Sign up」をクリック

2. **アカウント情報を入力**
   - メールアドレス
   - パスワード
   - ユーザー名
   - メール認証を完了

3. **プラン選択**
   - 無料プラン（Free）を選択

#### 1-2. 新しいリポジトリの作成

1. **GitHubにログイン後**
   - 右上の「+」マーク → 「New repository」をクリック

2. **リポジトリ情報を入力**
   ```
   Repository name: my-routine
   Description: 自分専用のルーチンワーク管理アプリ
   Public/Private: Public（公開）を選択
   ☑ Add a README file: チェックしない（既にREADME.mdがあるため）
   ```

3. **「Create repository」をクリック**

4. **リポジトリのURLをコピー**
   - 例: `https://github.com/あなたのユーザー名/my-routine.git`

#### 1-3. ローカルのコードをGitHubにプッシュ

このステップは開発者（私）が実行します。
あなたは以下の情報を教えてください：

```
必要な情報：
- GitHubのユーザー名
- リポジトリ名（例: my-routine）
- Personal Access Token（後で説明します）
```

**Personal Access Tokenの作成方法：**

1. GitHubで右上のアイコン → 「Settings」
2. 左側メニューの一番下「Developer settings」
3. 「Personal access tokens」→「Tokens (classic)」
4. 「Generate new token」→「Generate new token (classic)」
5. 以下を設定：
   ```
   Note: My ROUTINE App
   Expiration: 90 days（または任意）
   Select scopes: ☑ repo（すべてにチェック）
   ```
6. 「Generate token」をクリック
7. **表示されたトークンをコピーして保存**（二度と表示されません！）

---

## Step 2: Supabaseのセットアップ

### 🎯 目標
データベースを準備して、ルーチンデータを永続的に保存できるようにします。

### 📝 必要なもの
- Supabaseアカウント（無料）
- メールアドレス

### 🔧 手順

#### 2-1. Supabaseアカウントの作成

1. **Supabaseにアクセス**
   - URL: https://supabase.com/
   - 「Start your project」をクリック

2. **アカウント作成**
   - GitHubアカウントでサインイン（推奨）
   - またはメールアドレスで登録

#### 2-2. 新しいプロジェクトの作成

1. **「New Project」をクリック**

2. **プロジェクト情報を入力**
   ```
   Name: my-routine
   Database Password: 強力なパスワードを設定（メモしておく！）
   Region: Northeast Asia (Tokyo) - 日本に近いサーバー
   Pricing Plan: Free（無料プラン）
   ```

3. **「Create new project」をクリック**
   - プロジェクトの作成には2-3分かかります
   - 完了するまで待ちます

#### 2-3. データベーステーブルの作成

1. **左側メニューから「Table Editor」をクリック**

2. **「Create a new table」をクリック**

3. **テーブル1: routine_masters（ルーチンマスター）**
   ```
   Name: routine_masters
   Description: ルーチンのマスターデータ
   Enable Row Level Security (RLS): チェックを外す（初心者向け）
   
   カラム（Columns）:
   - id: int8, Primary Key, Auto Increment（デフォルト）
   - title: text, Required
   - display_order: int4, Required, Default: 0
   - created_at: timestamptz, Default: now()
   - user_id: text（将来の拡張用）
   ```
   
   **「Save」をクリック**

4. **テーブル2: daily_logs（日次ログ）**
   ```
   Name: daily_logs
   Description: 日々の完了記録
   Enable Row Level Security (RLS): チェックを外す
   
   カラム（Columns）:
   - id: int8, Primary Key, Auto Increment
   - date: date, Required, Unique
   - done_count: int4, Default: 0
   - total_routine_count: int4, Default: 0
   - completed_task_ids: jsonb（JSON形式）
   - created_at: timestamptz, Default: now()
   - user_id: text（将来の拡張用）
   ```
   
   **「Save」をクリック**

#### 2-4. APIキーの取得

1. **左側メニューから「Settings」（歯車アイコン）→「API」をクリック**

2. **以下の情報をコピーして保存**
   ```
   Project URL: https://xxxxx.supabase.co
   anon public: eyJhbGc...（長いキー）
   ```

3. **メモ帳などに保存**
   ```
   SUPABASE_URL=https://xxxxx.supabase.co
   SUPABASE_ANON_KEY=eyJhbGc...
   ```

---

## Step 3: アプリとSupabaseの連携

### 🎯 目標
LocalStorageからSupabaseデータベースに切り替えて、データを永続化します。

### 📝 必要なもの
- Step 2で取得したSupabaseのAPIキー

### 🔧 手順

#### 3-1. コードの修正

このステップは開発者（私）が実行します。
あなたは以下の情報を教えてください：

```
必要な情報：
- SUPABASE_URL（Step 2-4で取得）
- SUPABASE_ANON_KEY（Step 2-4で取得）
```

修正内容：
- Supabase JavaScript SDKの追加
- データ保存先をLocalStorage → Supabaseに変更
- CRUD操作の実装（Create, Read, Update, Delete）

#### 3-2. 動作確認

修正後、以下を確認します：
- ✅ ルーチンの追加ができる
- ✅ ルーチンの編集ができる
- ✅ ルーチンの削除ができる
- ✅ タスク完了が記録される
- ✅ グラフにデータが表示される

#### 3-3. GitHubにプッシュ

修正したコードをGitHubにプッシュします。
これで、Vercelデプロイの準備が整います。

---

## Step 4: Vercelへのデプロイ

### 🎯 目標
アプリを全世界に公開して、どこからでもアクセスできるようにします。

### 📝 必要なもの
- Vercelアカウント（無料）
- GitHubアカウント（Step 1で作成済み）

### 🔧 手順

#### 4-1. Vercelアカウントの作成

1. **Vercelにアクセス**
   - URL: https://vercel.com/
   - 「Sign Up」をクリック

2. **GitHubアカウントでサインイン**
   - 「Continue with GitHub」をクリック
   - GitHubの認証を許可

#### 4-2. プロジェクトのインポート

1. **ダッシュボードで「Add New...」→「Project」をクリック**

2. **「Import Git Repository」セクション**
   - GitHubリポジトリ一覧が表示されます
   - 「my-routine」を探して「Import」をクリック

3. **プロジェクト設定**
   ```
   Project Name: my-routine（自動入力）
   Framework Preset: Other（静的HTMLのため）
   Root Directory: ./（そのまま）
   Build Command: 空欄（静的HTMLなのでビルド不要）
   Output Directory: 空欄
   Install Command: 空欄
   ```

#### 4-3. 環境変数の設定

1. **「Environment Variables」セクションを展開**

2. **以下を追加**
   ```
   Key: VITE_SUPABASE_URL
   Value: https://xxxxx.supabase.co（Step 2-4で取得したURL）
   
   Key: VITE_SUPABASE_ANON_KEY
   Value: eyJhbGc...（Step 2-4で取得したキー）
   ```

3. **各環境にチェック**
   - ☑ Production
   - ☑ Preview
   - ☑ Development

#### 4-4. デプロイ実行

1. **「Deploy」ボタンをクリック**

2. **デプロイの進行状況を確認**
   - ビルドログが表示されます
   - 通常1-2分で完了します

3. **デプロイ完了**
   - 「Congratulations!」のメッセージが表示されます
   - 公開URLが生成されます
   - 例: `https://my-routine-xxxxx.vercel.app`

#### 4-5. カスタムドメインの設定（オプション）

1. **プロジェクトダッシュボードから「Settings」→「Domains」**

2. **独自ドメインを追加**
   ```
   例: my-routine.com
   ```

3. **DNSレコードを設定**
   - Vercelが指示するCNAMEレコードを、ドメイン管理画面で設定

---

## 🎉 完了！

おめでとうございます！これで以下が完了しました：

✅ **GitHubリポジトリ**: コードのバージョン管理  
✅ **Supabaseデータベース**: データの永続化  
✅ **Vercel公開**: 世界中からアクセス可能  

### 公開されたアプリのURL
```
https://my-routine-xxxxx.vercel.app
```

このURLをブックマークして、いつでもアクセスできます！

---

## トラブルシューティング

### ❌ GitHub Pushでエラーが出る

**エラー**: `Permission denied`

**解決策**:
- Personal Access Tokenを再確認
- トークンの権限に「repo」が含まれているか確認
- トークンの有効期限が切れていないか確認

---

### ❌ Supabaseに接続できない

**エラー**: `Failed to fetch`

**解決策**:
1. Supabaseのプロジェクトが起動しているか確認
2. APIキーが正しいか確認
3. ブラウザのコンソールでエラーメッセージを確認
4. RLS（Row Level Security）が無効になっているか確認

---

### ❌ Vercelのデプロイが失敗する

**エラー**: `Build failed`

**解決策**:
1. GitHubリポジトリにindex.htmlがあるか確認
2. ファイル名のスペルミスがないか確認
3. Vercelのビルドログを確認
4. 環境変数が正しく設定されているか確認

---

### ❌ デプロイ後、データが保存されない

**確認ポイント**:
1. Vercelの環境変数にSupabase情報が設定されているか
2. Supabaseのテーブルが正しく作成されているか
3. ブラウザの開発者ツールでネットワークエラーを確認
4. Supabaseのダッシュボードで実際のデータを確認

---

## 📚 参考リンク

- **GitHub Docs**: https://docs.github.com/ja
- **Supabase Docs**: https://supabase.com/docs
- **Vercel Docs**: https://vercel.com/docs

---

## 💡 次のステップ（オプション）

デプロイ後、さらに以下の機能を追加できます：

1. **認証機能**: Supabase Authで複数ユーザー対応
2. **PWA化**: オフラインでも使えるアプリに
3. **通知機能**: タスクのリマインダー
4. **テーマ切り替え**: ライトモード追加
5. **エクスポート機能**: データのバックアップ

---

## ❓ 質問があれば

わからないことがあれば、いつでも聞いてください！
このガイドを見ながら、一緒に進めていきましょう 🚀
