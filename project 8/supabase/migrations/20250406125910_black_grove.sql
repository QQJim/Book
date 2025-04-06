/*
  # 建立書籍和等待清單資料表

  1. 新資料表
    - `books` (書籍資料表)
      - `id` (text, 主鍵) - 對應現有書籍 ID
      - `title` (text) - 書名
      - `series` (text) - 系列名稱
      - `created_at` (timestamp with time zone) - 建立時間
    
    - `waiting_list` (等待清單資料表)
      - `id` (uuid, 主鍵)
      - `book_id` (text, 外鍵連結到 books.id)
      - `user_email` (text) - 使用者電子郵件
      - `created_at` (timestamp with time zone) - 建立時間

  2. 安全性設定
    - 啟用兩個資料表的資料列級安全性 (RLS)
    - 新增允許已驗證使用者讀取所有書籍的政策
    - 新增允許已驗證使用者讀取和建立等待清單項目的政策
*/

-- 建立書籍資料表
CREATE TABLE IF NOT EXISTS books (
  id text PRIMARY KEY,
  title text NOT NULL,
  series text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- 建立等待清單資料表
CREATE TABLE IF NOT EXISTS waiting_list (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id text REFERENCES books(id) ON DELETE CASCADE,
  user_email text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- 啟用資料列級安全性
ALTER TABLE books ENABLE ROW LEVEL SECURITY;
ALTER TABLE waiting_list ENABLE ROW LEVEL SECURITY;

-- 書籍資料表的存取政策
CREATE POLICY "允許公開讀取書籍資料"
  ON books
  FOR SELECT
  TO public
  USING (true);

-- 等待清單的存取政策
CREATE POLICY "允許已驗證使用者讀取等待清單"
  ON waiting_list
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "允許已驗證使用者新增等待清單項目"
  ON waiting_list
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- 插入初始書籍資料
INSERT INTO books (id, title, series)
VALUES
  ('pj-1', '神火之賊', '波西傑克森'),
  ('pj-2', '魔獸之海', '波西傑克森'),
  ('pj-3', '泰坦魔咒', '波西傑克森'),
  ('pj-4', '迷宮戰場', '波西傑克森'),
  ('pj-5', '終戰時刻', '波西傑克森'),
  ('pj-6', '眾神之謎', '波西傑克森'),
  ('pj-7', '英雄之血', '波西傑克森'),
  ('hoh-1', '迷失英雄', '混血營英雄'),
  ('hoh-2', '海神之子', '混血營英雄'),
  ('hoh-3', '冥王印記', '混血營英雄'),
  ('hoh-4', '冥府之屋', '混血營英雄'),
  ('hoh-5', '英雄之血', '混血營英雄'),
  ('tot-1', '隱形神諭', '太陽神試煉'),
  ('tot-2', '黑暗預言', '太陽神試煉'),
  ('tot-3', '燃燒迷宮', '太陽神試煉'),
  ('tot-4', '火之王冠', '太陽神試煉'),
  ('tot-5', '眾神之戰', '太陽神試煉'),
  ('kc-1', '紅色金字塔', '埃及守護神'),
  ('kc-2', '火之王座', '埃及守護神'),
  ('kc-3', '巫蛇之影', '埃及守護神')
ON CONFLICT (id) DO NOTHING;