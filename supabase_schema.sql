-- My ROUTINE用のSupabaseテーブル定義

-- routine_mastersテーブルの作成
CREATE TABLE IF NOT EXISTS routine_masters (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    user_id TEXT
);

-- RLSを無効化（開発用）
ALTER TABLE routine_masters DISABLE ROW LEVEL SECURITY;

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_routine_masters_display_order ON routine_masters(display_order);

-- daily_logsテーブルの作成
CREATE TABLE IF NOT EXISTS daily_logs (
    id BIGSERIAL PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    done_count INTEGER DEFAULT 0,
    total_routine_count INTEGER DEFAULT 0,
    completed_task_ids JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    user_id TEXT
);

-- RLSを無効化（開発用）
ALTER TABLE daily_logs DISABLE ROW LEVEL SECURITY;

-- インデックス作成
CREATE INDEX IF NOT EXISTS idx_daily_logs_date ON daily_logs(date);

-- サンプルデータの挿入（オプション）
INSERT INTO routine_masters (title, display_order, created_at)
VALUES 
    ('朝のストレッチ', 1, NOW()),
    ('コーヒーを飲む', 2, NOW()),
    ('ニュースをチェック', 3, NOW()),
    ('コードレビュー', 4, NOW()),
    ('筋トレ', 5, NOW()),
    ('読書', 6, NOW())
ON CONFLICT DO NOTHING;
