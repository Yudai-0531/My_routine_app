# My ROUTINE - デプロイメントフロー

## 📋 概要

このドキュメントは、「My ROUTINE」アプリをローカル開発からプロダクション環境へデプロイするまでの最適なフローを示します。

---

## 🎯 推奨フロー（全体像）

```
1. GitHubリポジトリへのプッシュ
   ↓
2. Supabase連携（データベース接続）
   ↓
3. Vercelへのデプロイ
   ↓
4. 動作確認・調整
```

---

## 📊 フェーズ別詳細

### 🔸 フェーズ1: GitHubリポジトリへのプッシュ

**目的**: コードのバージョン管理とVercelとの連携準備

#### 必要な情報
- [ ] GitHubアカウント
- [ ] リポジトリ名（例: my-routine）
- [ ] リポジトリの可視性（Public / Private）

#### 作業内容
1. GitHubで新規リポジトリ作成
2. ローカルリポジトリの初期化（完了済み）
3. リモートリポジトリの設定
4. 初回コミット＆プッシュ
5. ブランチ戦略の確認

#### 成果物
- ✅ GitHubにコードが保存される
- ✅ バージョン管理が可能になる
- ✅ Vercelとの連携準備完了

#### 所要時間
約5分

---

### 🔸 フェーズ2: Supabase連携（データベース接続）

**目的**: LocalStorageからSupabaseへデータ保存先を移行

#### 必要な情報
- [ ] Supabaseアカウント
- [ ] プロジェクト名（例: my-routine）
- [ ] Supabase URL
- [ ] Supabase API Key（anon/public key）

#### 事前準備
1. **Supabaseプロジェクト作成**
   - https://supabase.com でプロジェクト作成
   - リージョン選択（推奨: Northeast Asia (Tokyo)）
   - データベースパスワード設定

2. **テーブル設計**
   ```sql
   -- routines テーブル
   CREATE TABLE routines (
     id BIGSERIAL PRIMARY KEY,
     title TEXT NOT NULL,
     display_order INTEGER NOT NULL,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- daily_logs テーブル
   CREATE TABLE daily_logs (
     id BIGSERIAL PRIMARY KEY,
     log_date DATE NOT NULL UNIQUE,
     done_count INTEGER DEFAULT 0,
     total_routine_count INTEGER DEFAULT 0,
     completed_task_ids BIGINT[] DEFAULT '{}',
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );
   ```

#### 作業内容
1. Supabase JavaScriptクライアントの導入（CDN）
2. データベース接続設定
3. LocalStorageロジックをSupabaseに置き換え
   - `getRoutines()` → Supabase SELECT
   - `saveRoutines()` → Supabase INSERT/UPDATE
   - `getDailyLogs()` → Supabase SELECT
   - `saveDailyLogs()` → Supabase INSERT/UPDATE
4. エラーハンドリング追加
5. 動作確認

#### 成果物
- ✅ データがSupabaseに永続化される
- ✅ ブラウザキャッシュクリアの影響を受けない
- ✅ 将来的な複数デバイス対応の準備完了

#### 所要時間
約30〜45分

---

### 🔸 フェーズ3: Vercelへのデプロイ

**目的**: 本番環境への公開

#### 必要な情報
- [ ] Vercelアカウント
- [ ] GitHubアカウント（連携用）
- [ ] Supabase環境変数
  - `VITE_SUPABASE_URL`
  - `VITE_SUPABASE_ANON_KEY`

#### 作業内容
1. **Vercelアカウント作成・連携**
   - https://vercel.com でサインアップ
   - GitHubアカウントで連携

2. **プロジェクトインポート**
   - 「New Project」をクリック
   - GitHubリポジトリを選択
   - プロジェクト設定
     - Framework Preset: `Other`
     - Build Command: （空欄）
     - Output Directory: `.`（ルート）

3. **環境変数の設定**
   ```
   VITE_SUPABASE_URL=https://xxxxx.supabase.co
   VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

4. **デプロイ実行**
   - 「Deploy」ボタンをクリック
   - 自動デプロイ完了まで待機（約1〜2分）

5. **カスタムドメイン設定（オプション）**
   - 独自ドメインがある場合は設定可能

#### 成果物
- ✅ 本番URLが発行される（例: `https://my-routine.vercel.app`）
- ✅ GitHubへのプッシュで自動デプロイ
- ✅ HTTPS対応
- ✅ グローバルCDN配信

#### 所要時間
約10〜15分

---

### 🔸 フェーズ4: 動作確認・調整

**目的**: 本番環境での動作確認と最適化

#### 確認項目
- [ ] HOMEページの表示確認
- [ ] タスク完了機能の動作確認
- [ ] ANALYSTページのグラフ表示確認
- [ ] ルーチン追加・編集・削除の動作確認
- [ ] Supabaseへのデータ保存確認
- [ ] レスポンシブデザインの確認（モバイル）

#### 調整項目
- パフォーマンス最適化
- エラーハンドリングの強化
- ローディング表示の追加
- SEO対策（metaタグ追加）

#### 所要時間
約15〜30分

---

## 🔄 開発ワークフロー（デプロイ後）

### 日常的な開発フロー
```
1. ローカルで機能追加・修正
   ↓
2. 動作確認（localhost）
   ↓
3. Gitコミット
   ↓
4. GitHubにプッシュ
   ↓
5. Vercelが自動デプロイ（約1分）
   ↓
6. 本番環境で確認
```

### ブランチ戦略（推奨）
```
main (本番環境)
  └── develop (開発環境)
       └── feature/* (機能追加ブランチ)
```

---

## 📦 必要なアカウント・サービス

| サービス | 用途 | 料金 | 必須 |
|---------|------|------|------|
| **GitHub** | コード管理 | 無料 | ✅ 必須 |
| **Supabase** | データベース | 無料枠あり（500MB） | ✅ 必須 |
| **Vercel** | ホスティング | 無料枠あり | ✅ 必須 |

すべて無料プランで開始できます！

---

## ⚠️ 注意事項

### セキュリティ
- [ ] Supabase API Keyは環境変数で管理（直接コードに書かない）
- [ ] Row Level Security (RLS) の設定（Supabase）
- [ ] CORS設定の確認

### パフォーマンス
- [ ] 画像の最適化
- [ ] JavaScriptの最小化
- [ ] CDNの活用（Vercel自動対応）

### バックアップ
- [ ] Supabaseの自動バックアップ確認
- [ ] 定期的なデータエクスポート

---

## 📝 チェックリスト（全体）

### 事前準備
- [ ] GitHubアカウント作成
- [ ] Supabaseアカウント作成
- [ ] Vercelアカウント作成

### フェーズ1: GitHub
- [ ] リポジトリ作成
- [ ] コードプッシュ完了
- [ ] README確認

### フェーズ2: Supabase
- [ ] プロジェクト作成
- [ ] テーブル作成
- [ ] API Key取得
- [ ] コード修正（LocalStorage → Supabase）
- [ ] ローカルで動作確認

### フェーズ3: Vercel
- [ ] プロジェクトインポート
- [ ] 環境変数設定
- [ ] デプロイ完了
- [ ] 本番URL確認

### フェーズ4: 最終確認
- [ ] 全機能の動作確認
- [ ] モバイル表示確認
- [ ] データ永続化確認

---

## 🚀 開始準備

### 今すぐ必要な情報
デプロイを開始するために、以下の情報を準備してください：

1. **GitHubリポジトリ名**
   - 例: `my-routine`
   - Public or Private?

2. **Supabaseプロジェクト情報**
   - プロジェクト名: 
   - URL: 
   - API Key: 

3. **Vercelプロジェクト名**
   - 例: `my-routine`（同じ名前推奨）

---

## 💡 推奨する作業順序の理由

### なぜこの順番？

1. **GitHub First（最初）**
   - バージョン管理を最初に確立
   - Vercelとの連携がスムーズ
   - コードのバックアップ確保

2. **Supabase Second（次）**
   - ローカルで十分テスト可能
   - デプロイ前に動作確認できる
   - 環境変数を安全に管理

3. **Vercel Last（最後）**
   - すべての機能が完成してからデプロイ
   - 一度設定すれば自動デプロイ
   - 本番環境で問題が起きにくい

---

## 📞 トラブルシューティング

### よくある問題

#### GitHub
- **Q: プッシュできない**
  - A: 認証情報の確認、リモートURL確認

#### Supabase
- **Q: データが保存されない**
  - A: RLS設定、API Key確認、ネットワークエラー確認

#### Vercel
- **Q: デプロイが失敗する**
  - A: 環境変数確認、ビルドログ確認

---

## 📚 参考リンク

- [GitHub Docs](https://docs.github.com/)
- [Supabase Documentation](https://supabase.com/docs)
- [Vercel Documentation](https://vercel.com/docs)

---

**次のステップ**: どのフェーズから始めますか？必要な情報を教えてください！
