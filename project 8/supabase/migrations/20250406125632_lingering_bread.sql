/*
  # Create books and waiting_list tables

  1. New Tables
    - `books`
      - `id` (text, primary key) - matches the existing book IDs
      - `title` (text)
      - `series` (text)
      - `created_at` (timestamp with time zone)
    
    - `waiting_list`
      - `id` (uuid, primary key)
      - `book_id` (text, foreign key to books.id)
      - `user_email` (text)
      - `created_at` (timestamp with time zone)

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users to read all books
    - Add policies for authenticated users to read and create waiting list entries
*/

-- Create books table
CREATE TABLE IF NOT EXISTS books (
  id text PRIMARY KEY,
  title text NOT NULL,
  series text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create waiting list table
CREATE TABLE IF NOT EXISTS waiting_list (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id text REFERENCES books(id) ON DELETE CASCADE,
  user_email text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE books ENABLE ROW LEVEL SECURITY;
ALTER TABLE waiting_list ENABLE ROW LEVEL SECURITY;

-- Policies for books table
CREATE POLICY "Allow public read access to books"
  ON books
  FOR SELECT
  TO public
  USING (true);

-- Policies for waiting list
CREATE POLICY "Allow authenticated users to read waiting list"
  ON waiting_list
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to add to waiting list"
  ON waiting_list
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Insert initial books data
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