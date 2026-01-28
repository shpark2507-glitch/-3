# 🔒 Git 업로드 가이드 (API 키 보호)

## ⚠️ 중요: API 키 보안

API 키가 Git에 업로드되면 **누구나 볼 수 있게** 되므로 반드시 제외해야 합니다.

## ✅ 안전 확인 사항

현재 프로젝트는 다음 보안 설정이 되어 있습니다:

1. ✅ `.gitignore`에 `.env*.local` 포함됨
2. ✅ `.env.local` 파일은 Git에 추가되지 않음
3. ✅ `.env.local.example`만 Git에 포함됨 (API 키 없음)

## 🚀 Git 업로드 방법

### 방법 1: 자동 스크립트 사용 (추천)

터미널에서 다음 명령어 실행:

```bash
cd ~/Desktop/챗봇
./git-upload.sh
```

이 스크립트가 자동으로:
- API 키 파일이 Git에 포함되지 않았는지 확인
- 안전한 파일들만 추가
- 커밋 생성

### 방법 2: 수동으로 업로드

#### 1단계: Git 저장소 초기화

```bash
cd ~/Desktop/챗봇
git init
```

#### 2단계: 현재 상태 확인

```bash
git status
```

**확인 사항:**
- `.env.local` 파일이 목록에 **없어야** 합니다
- `node_modules/` 폴더가 목록에 **없어야** 합니다

#### 3단계: 파일 추가

```bash
git add .
```

#### 4단계: 다시 확인 (중요!)

```bash
git status
```

**반드시 확인:**
- `.env.local`이 목록에 **없어야** 합니다
- 만약 있다면 즉시 제거:
  ```bash
  git reset HEAD .env.local
  ```

#### 5단계: 커밋

```bash
git commit -m "Initial commit: 뉴스 챗봇 프로젝트"
```

#### 6단계: 원격 저장소 연결

GitHub/GitLab 등에 저장소를 만든 후:

```bash
git remote add origin <원격저장소URL>
```

예시:
```bash
git remote add origin https://github.com/사용자명/뉴스챗봇.git
```

#### 7단계: 푸시

```bash
git branch -M main
git push -u origin main
```

## 🔍 API 키 노출 확인 방법

업로드 후 다음을 확인하세요:

1. GitHub/GitLab에서 저장소 열기
2. `.env.local` 파일이 있는지 검색
3. 파일 내용에 API 키가 있는지 확인

**만약 API 키가 노출되었다면:**
1. 즉시 API 키를 재발급 (https://makersuite.google.com/app/apikey)
2. `.env.local` 파일을 Git에서 제거:
   ```bash
   git rm --cached .env.local
   git commit -m "Remove .env.local from Git"
   git push
   ```
3. Git 히스토리에서 완전히 제거 (필요시)

## 📋 Git에 포함되어야 할 파일

✅ **포함해야 할 파일:**
- 소스 코드 (`.ts`, `.tsx`, `.js`, `.jsx`)
- 설정 파일 (`package.json`, `tsconfig.json`, `next.config.js`)
- 문서 파일 (`README.md`, `.md` 파일들)
- `.env.local.example` (API 키 없음)
- `.gitignore`

❌ **포함하면 안 되는 파일:**
- `.env.local` (API 키 포함)
- `node_modules/` (의존성 패키지)
- `.next/` (빌드 결과물)
- `.DS_Store` (macOS 시스템 파일)

## 🛡️ 추가 보안 권장사항

1. **GitHub Secrets 사용** (GitHub Actions 사용 시)
2. **Vercel 환경 변수 사용** (배포 시)
3. **API 키 권한 제한** (가능한 경우)
4. **정기적으로 API 키 로테이션**

## ✅ 최종 체크리스트

업로드 전 확인:
- [ ] `.env.local`이 `.gitignore`에 포함되어 있음
- [ ] `git status`에서 `.env.local`이 보이지 않음
- [ ] `.env.local.example`만 Git에 포함됨
- [ ] `node_modules/`가 Git에 포함되지 않음
- [ ] README에 API 키 설정 방법이 명시됨

업로드 후 확인:
- [ ] 원격 저장소에서 `.env.local` 파일이 없음
- [ ] `.env.local.example` 파일만 있음
- [ ] API 키가 코드나 설정 파일에 하드코딩되지 않음

---

**안전하게 업로드하세요!** 🔒
