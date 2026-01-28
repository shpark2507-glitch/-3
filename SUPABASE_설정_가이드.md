# 🗄️ Supabase 설정 가이드

## Supabase를 활용한 뉴스 데이터베이스 관리

### 데이터베이스 구조

1. **news_searches** - 검색 키워드 기록
   - `id` (UUID) - 고유 식별자
   - `keyword` (TEXT) - 검색 키워드
   - `created_at` (TIMESTAMP) - 검색 시간

2. **news_articles** - 뉴스 기사 정보
   - `id` (UUID) - 고유 식별자
   - `search_id` (UUID) - 검색 기록 ID (외래키)
   - `title` (TEXT) - 뉴스 제목
   - `url` (TEXT) - 뉴스 링크
   - `snippet` (TEXT) - 뉴스 내용 요약
   - `created_at` (TIMESTAMP) - 저장 시간

---

## 설정 방법

### 1단계: Supabase 프로젝트 생성

1. **Supabase 웹사이트 접속**
   - https://supabase.com 접속
   - 로그인 또는 회원가입

2. **새 프로젝트 생성**
   - "New Project" 클릭
   - 프로젝트 이름 입력 (예: "news-chatbot")
   - 데이터베이스 비밀번호 설정
   - 리전 선택 (가장 가까운 리전)
   - "Create new project" 클릭

3. **프로젝트 생성 완료 대기**
   - 약 2-3분 소요

---

### 2단계: 데이터베이스 스키마 생성

1. **SQL Editor 열기**
   - Supabase 대시보드에서 왼쪽 메뉴의 "SQL Editor" 클릭

2. **스키마 파일 복사**
   - 프로젝트의 `supabase/schema.sql` 파일 내용 복사

3. **SQL 실행**
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭
   - 성공 메시지 확인

---

### 3단계: API 키 확인

1. **Settings 메뉴**
   - Supabase 대시보드에서 왼쪽 메뉴의 "Settings" 클릭
   - "API" 섹션 선택

2. **필요한 정보 확인**
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

---

### 4단계: 환경 변수 설정

#### 로컬 개발 환경

`.env.local` 파일에 추가:

```bash
# Supabase 설정
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Vercel 배포 환경

1. **Vercel 대시보드 접속**
   - https://vercel.com 접속
   - 프로젝트 선택

2. **환경 변수 추가**
   - Settings > Environment Variables
   - 다음 변수 추가:
     - `NEXT_PUBLIC_SUPABASE_URL`: Supabase Project URL
     - `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Supabase anon public key

3. **재배포**
   - 환경 변수 추가 후 자동 재배포 또는 수동 재배포

---

## 사용 방법

### 뉴스 검색 시 자동 저장

뉴스를 검색하면 자동으로 DB에 저장됩니다:

```typescript
// app/api/search-news/route.ts에서 자동 처리
// 검색 키워드와 뉴스 기사가 자동으로 DB에 저장됨
```

### 검색 기록 조회

```bash
# 모든 검색 기록 조회
GET /api/news/history

# 최근 10개만 조회
GET /api/news/history?limit=10

# 특정 키워드로 필터링
GET /api/news/history?keyword=인공지능
```

### 뉴스 기사 조회

```bash
# 모든 뉴스 기사 조회
GET /api/news/articles

# 특정 검색의 뉴스만 조회
GET /api/news/articles?search_id=uuid-here

# 키워드로 필터링
GET /api/news/articles?keyword=기술
```

---

## API 엔드포인트

### 1. 검색 기록 조회
```
GET /api/news/history
GET /api/news/history?limit=20
GET /api/news/history?keyword=인공지능
```

**응답 예시:**
```json
{
  "searches": [
    {
      "id": "uuid",
      "keyword": "인공지능",
      "created_at": "2025-01-27T...",
      "news_articles": [
        {
          "id": "uuid",
          "title": "뉴스 제목",
          "url": "https://...",
          "snippet": "뉴스 내용...",
          "created_at": "2025-01-27T..."
        }
      ]
    }
  ]
}
```

### 2. 뉴스 기사 조회
```
GET /api/news/articles
GET /api/news/articles?limit=50
GET /api/news/articles?search_id=uuid
GET /api/news/articles?keyword=기술
```

**응답 예시:**
```json
{
  "articles": [
    {
      "id": "uuid",
      "title": "뉴스 제목",
      "url": "https://...",
      "snippet": "뉴스 내용...",
      "created_at": "2025-01-27T...",
      "news_searches": {
        "id": "uuid",
        "keyword": "인공지능",
        "created_at": "2025-01-27T..."
      }
    }
  ]
}
```

---

## 데이터 확인

### Supabase 대시보드에서 확인

1. **Table Editor**
   - Supabase 대시보드 > "Table Editor"
   - `news_searches` 테이블 확인
   - `news_articles` 테이블 확인

2. **SQL Editor**
   - 직접 SQL 쿼리 실행 가능
   ```sql
   SELECT * FROM news_searches ORDER BY created_at DESC LIMIT 10;
   SELECT * FROM news_articles ORDER BY created_at DESC LIMIT 10;
   ```

---

## 문제 해결

### "Supabase 환경 변수가 설정되지 않았습니다"
- `.env.local` 파일 확인
- Vercel 환경 변수 확인
- 서버 재시작

### "relation does not exist"
- SQL 스키마가 실행되지 않음
- `supabase/schema.sql` 파일을 SQL Editor에서 실행

### "permission denied"
- Row Level Security (RLS) 정책 확인
- 스키마 파일의 RLS 정책이 올바르게 설정되었는지 확인

---

## 보안 주의사항

1. **API 키 보호**
   - `anon public key`는 공개되어도 되지만, `service_role key`는 절대 노출하지 마세요
   - `.env.local` 파일은 Git에 커밋하지 마세요

2. **Row Level Security (RLS)**
   - 현재 설정은 모든 사용자가 읽기/쓰기 가능
   - 필요시 더 세밀한 권한 설정 가능

---

## 다음 단계

1. ✅ Supabase 프로젝트 생성
2. ✅ 데이터베이스 스키마 생성
3. ✅ 환경 변수 설정
4. ✅ 뉴스 검색 테스트 (자동 저장 확인)
5. ✅ Supabase 대시보드에서 데이터 확인

---

**설정 완료 후 뉴스를 검색하면 자동으로 DB에 저장됩니다!** 🎉
