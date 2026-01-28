# 뉴스 챗봇

키워드를 입력하면 구글에서 관련 뉴스를 검색하고, 뉴스를 요약하며, 뉴스에 대해 대화할 수 있는 챗봇입니다.

## 기능

- 🔍 키워드 기반 뉴스 검색 (10개)
- 📝 뉴스 자동 요약
- 💬 뉴스 기반 대화형 챗봇
- 🎨 모던한 UI 디자인

## 기술 스택

- Next.js 14
- React 18
- TypeScript
- Google Gemini API

## 설치 및 실행

### 1. 의존성 설치

```bash
npm install
```

### 2. 환경 변수 설정

`.env.local` 파일을 생성하고 다음 내용을 추가하세요:

```
NEXT_PUBLIC_GEMINI_API_KEY=your_gemini_api_key_here
```

### 3. Vercel 배포 시 환경 변수 설정

1. Vercel 프로젝트 설정으로 이동
2. Settings > Environment Variables 메뉴 선택
3. 다음 환경 변수 추가:
   - Key: `NEXT_PUBLIC_GEMINI_API_KEY`
   - Value: 본인의 Gemini API 키 (https://makersuite.google.com/app/apikey 에서 발급)

### 4. 개발 서버 실행

```bash
npm run dev
```

브라우저에서 [http://localhost:3000](http://localhost:3000)을 열어 확인하세요.

## 사용 방법

1. 검색창에 키워드를 입력합니다 (예: "인공지능", "기술", "경제" 등)
2. "검색" 버튼을 클릭합니다
3. 검색된 뉴스 10개와 요약을 확인합니다
4. 챗봇 섹션에서 뉴스에 대해 질문할 수 있습니다

## 주의사항

- API 키는 절대 공개 저장소에 커밋하지 마세요
- `.env.local` 파일은 `.gitignore`에 포함되어 있습니다
- Vercel 배포 시 환경 변수를 반드시 설정해야 합니다
