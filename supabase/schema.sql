-- Supabase 데이터베이스 스키마
-- Supabase 대시보드 > SQL Editor에서 실행하세요

-- 1. 뉴스 검색 기록 테이블
CREATE TABLE IF NOT EXISTS news_searches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  keyword TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. 뉴스 기사 테이블
CREATE TABLE IF NOT EXISTS news_articles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  search_id UUID NOT NULL REFERENCES news_searches(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  url TEXT,
  snippet TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 인덱스 생성 (검색 성능 향상)
CREATE INDEX IF NOT EXISTS idx_news_searches_keyword ON news_searches(keyword);
CREATE INDEX IF NOT EXISTS idx_news_searches_created_at ON news_searches(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_news_articles_search_id ON news_articles(search_id);
CREATE INDEX IF NOT EXISTS idx_news_articles_created_at ON news_articles(created_at DESC);

-- 4. Row Level Security (RLS) 활성화
ALTER TABLE news_searches ENABLE ROW LEVEL SECURITY;
ALTER TABLE news_articles ENABLE ROW LEVEL SECURITY;

-- 5. RLS 정책 설정 (모든 사용자가 읽기/쓰기 가능)
CREATE POLICY "Allow all operations on news_searches" ON news_searches
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations on news_articles" ON news_articles
  FOR ALL USING (true) WITH CHECK (true);

-- 6. 뷰 생성 (검색 기록과 기사 조인)
CREATE OR REPLACE VIEW news_with_searches AS
SELECT 
  ns.id as search_id,
  ns.keyword,
  ns.created_at as search_created_at,
  na.id as article_id,
  na.title,
  na.url,
  na.snippet,
  na.created_at as article_created_at
FROM news_searches ns
LEFT JOIN news_articles na ON ns.id = na.search_id
ORDER BY ns.created_at DESC, na.created_at DESC;
