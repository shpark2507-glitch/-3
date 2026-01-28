# 🚀 Vercel 배포 가이드

## Vercel에 API 키 설정하기

### 방법 1: Vercel 대시보드에서 설정 (추천)

#### 1단계: Vercel 프로젝트로 이동

1. **Vercel 웹사이트 접속**
   - https://vercel.com 접속
   - 로그인 (GitHub 계정으로 로그인 가능)

2. **프로젝트 선택**
   - 대시보드에서 배포할 프로젝트 클릭
   - 또는 새 프로젝트 생성

#### 2단계: 환경 변수 설정

1. **Settings 메뉴 클릭**
   - 프로젝트 페이지 상단의 "Settings" 탭 클릭

2. **Environment Variables 메뉴 선택**
   - 왼쪽 사이드바에서 "Environment Variables" 클릭
   - 또는 Settings 페이지에서 "Environment Variables" 섹션 찾기

3. **새 환경 변수 추가**
   - "Add New" 또는 "+" 버튼 클릭

4. **환경 변수 입력**
   - **Key (이름)**: `NEXT_PUBLIC_GEMINI_API_KEY`
   - **Value (값)**: `AIzaSyD90VWX__C42A8kYnnKm8FtDlNCYw6sM6Y`
   - **Environment (환경)**: 
     - ✅ Production (프로덕션)
     - ✅ Preview (프리뷰)
     - ✅ Development (개발)
     - 모두 선택하는 것을 권장합니다

5. **저장**
   - "Save" 또는 "Add" 버튼 클릭

#### 3단계: 재배포 (중요!)

환경 변수를 추가한 후 **반드시 재배포**해야 합니다:

1. **Deployments 탭으로 이동**
   - 상단 메뉴에서 "Deployments" 클릭

2. **최신 배포 선택**
   - 가장 최근 배포를 클릭

3. **Redeploy 클릭**
   - 우측 상단의 "..." 메뉴 클릭
   - "Redeploy" 선택
   - 또는 "Redeploy" 버튼 직접 클릭

4. **확인**
   - "Redeploy" 버튼 클릭하여 재배포 시작

---

### 방법 2: Vercel CLI로 설정

터미널에서 직접 설정할 수도 있습니다:

#### 1단계: Vercel CLI 설치

```bash
npm install -g vercel
```

#### 2단계: Vercel 로그인

```bash
vercel login
```

#### 3단계: 프로젝트 연결

```bash
cd ~/Desktop/챗봇
vercel link
```

#### 4단계: 환경 변수 추가

```bash
vercel env add NEXT_PUBLIC_GEMINI_API_KEY
```

프롬프트가 나타나면:
- **Value**: `AIzaSyD90VWX__C42A8kYnnKm8FtDlNCYw6sM6Y` 입력
- **Environment**: `production`, `preview`, `development` 모두 선택 (스페이스바로 선택)

#### 5단계: 재배포

```bash
vercel --prod
```

---

## 📋 환경 변수 설정 체크리스트

설정 완료 후 확인:

- [ ] Key 이름이 정확히 `NEXT_PUBLIC_GEMINI_API_KEY`인가?
- [ ] Value에 API 키가 올바르게 입력되었는가?
- [ ] Production, Preview, Development 모두 선택했는가?
- [ ] 저장 후 재배포를 했는가?

---

## 🔍 환경 변수 확인 방법

### 방법 1: Vercel 대시보드에서 확인

1. Settings > Environment Variables로 이동
2. `NEXT_PUBLIC_GEMINI_API_KEY`가 목록에 있는지 확인
3. Value는 마스킹되어 표시됩니다 (보안상 이유)

### 방법 2: 배포된 사이트에서 확인

배포된 사이트에서 키워드 검색을 시도해보세요:
- 정상 작동하면 환경 변수가 올바르게 설정된 것입니다
- 오류가 발생하면 환경 변수 설정을 다시 확인하세요

---

## ⚠️ 주의사항

1. **API 키 보안**
   - API 키는 절대 코드에 하드코딩하지 마세요
   - 환경 변수로만 관리하세요
   - 공개 저장소에 커밋하지 마세요

2. **재배포 필요**
   - 환경 변수를 추가/수정한 후 반드시 재배포해야 합니다
   - 재배포하지 않으면 변경사항이 적용되지 않습니다

3. **환경별 설정**
   - Production, Preview, Development 환경에 각각 설정할 수 있습니다
   - 모든 환경에 동일한 API 키를 사용하는 것을 권장합니다

---

## 🐛 문제 해결

### 문제 1: 환경 변수가 작동하지 않음

**해결 방법:**
1. 환경 변수 이름이 정확한지 확인 (`NEXT_PUBLIC_GEMINI_API_KEY`)
2. 재배포를 했는지 확인
3. 브라우저 캐시 삭제 후 다시 시도

### 문제 2: "API 키가 설정되지 않았습니다" 오류

**해결 방법:**
1. Vercel 대시보드에서 환경 변수가 올바르게 설정되었는지 확인
2. 환경 변수 이름에 오타가 없는지 확인
3. 재배포 실행

### 문제 3: 환경 변수가 보이지 않음

**해결 방법:**
1. Settings > Environment Variables 경로 확인
2. 올바른 프로젝트를 선택했는지 확인
3. Vercel 계정 권한 확인

---

## 📸 스크린샷 가이드

### Vercel 대시보드에서 환경 변수 설정 위치:

```
Vercel 대시보드
  └─ 프로젝트 선택
      └─ Settings (상단 탭)
          └─ Environment Variables (왼쪽 사이드바)
              └─ Add New 버튼
```

### 환경 변수 입력 예시:

```
Key:   NEXT_PUBLIC_GEMINI_API_KEY
Value: AIzaSyD90VWX__C42A8kYnnKm8FtDlNCYw6sM6Y

Environment:
☑ Production
☑ Preview  
☑ Development
```

---

## ✅ 완료 후 확인

환경 변수 설정 및 재배포 후:

1. 배포된 사이트 URL 접속
2. 키워드 검색 테스트 (예: "인공지능")
3. 뉴스가 정상적으로 표시되는지 확인
4. 챗봇이 정상 작동하는지 확인

모든 것이 정상 작동하면 성공입니다! 🎉

---

## 📞 추가 도움

문제가 계속되면:
1. Vercel 로그 확인 (Deployments > 최신 배포 > Logs)
2. 브라우저 개발자 도구 Console 확인
3. 환경 변수 설정 다시 확인
