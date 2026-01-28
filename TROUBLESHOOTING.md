# 문제 해결 가이드

## 브라우저에서 localhost:3000이 열리지 않는 경우

### 1. Node.js 설치 확인
터미널에서 다음 명령어를 실행하여 Node.js가 설치되어 있는지 확인하세요:

```bash
node --version
npm --version
```

Node.js가 설치되어 있지 않다면:
- macOS: [nodejs.org](https://nodejs.org/)에서 다운로드하거나 `brew install node` 실행
- 또는 nvm을 사용하여 설치: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash`

### 2. 의존성 설치
프로젝트 폴더에서 다음 명령어를 실행하세요:

```bash
cd /Users/parkkun/Desktop/챗봇
npm install
```

### 3. 개발 서버 실행
의존성 설치가 완료되면 다음 명령어로 개발 서버를 실행하세요:

```bash
npm run dev
```

성공적으로 실행되면 다음과 같은 메시지가 표시됩니다:
```
  ▲ Next.js 14.x.x
  - Local:        http://localhost:3000
  - Ready in X.Xs
```

### 4. 브라우저에서 확인
개발 서버가 실행된 후 브라우저에서 `http://localhost:3000`을 열어보세요.

### 5. 일반적인 오류 해결

#### "포트 3000이 이미 사용 중입니다"
다른 포트를 사용하려면:
```bash
PORT=3001 npm run dev
```

#### "모듈을 찾을 수 없습니다"
의존성을 다시 설치하세요:
```bash
rm -rf node_modules package-lock.json
npm install
```

#### "API 키 오류"
`.env.local` 파일이 올바른 위치에 있고 API 키가 설정되어 있는지 확인하세요:
```bash
cat .env.local
```

### 6. 브라우저 개발자 도구 확인
브라우저에서 F12를 눌러 개발자 도구를 열고 Console 탭에서 오류 메시지를 확인하세요.
