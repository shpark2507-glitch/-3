#!/bin/bash

echo "🚀 뉴스 챗봇 시작 스크립트"
echo "================================"
echo ""

# 1. Node.js 확인
echo "1️⃣ Node.js 설치 확인 중..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js가 설치되어 있지 않습니다."
    echo "   https://nodejs.org/ 에서 Node.js를 설치해주세요."
    exit 1
fi

NODE_VERSION=$(node --version)
echo "✅ Node.js 설치됨: $NODE_VERSION"
echo ""

# 2. npm 확인
echo "2️⃣ npm 확인 중..."
if ! command -v npm &> /dev/null; then
    echo "❌ npm이 설치되어 있지 않습니다."
    exit 1
fi

NPM_VERSION=$(npm --version)
echo "✅ npm 설치됨: $NPM_VERSION"
echo ""

# 3. 프로젝트 폴더로 이동
echo "3️⃣ 프로젝트 폴더로 이동 중..."
cd "$(dirname "$0")"
echo "✅ 현재 위치: $(pwd)"
echo ""

# 4. node_modules 확인
echo "4️⃣ 의존성 패키지 확인 중..."
if [ ! -d "node_modules" ]; then
    echo "⚠️  node_modules 폴더가 없습니다. 설치를 시작합니다..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ npm install 실패"
        exit 1
    fi
    echo "✅ 의존성 패키지 설치 완료"
else
    echo "✅ 의존성 패키지가 이미 설치되어 있습니다"
fi
echo ""

# 5. 환경 변수 확인
echo "5️⃣ 환경 변수 확인 중..."
if [ ! -f ".env.local" ]; then
    echo "⚠️  .env.local 파일이 없습니다. 생성합니다..."
    echo "NEXT_PUBLIC_GEMINI_API_KEY=AIzaSyDgO2AxMYt-Fd7aMBA9Lu4o5ku0bGulNu4" > .env.local
    echo "✅ .env.local 파일 생성 완료"
else
    echo "✅ .env.local 파일이 존재합니다"
fi
echo ""

# 6. 개발 서버 시작
echo "6️⃣ 개발 서버 시작 중..."
echo "================================"
echo "🌐 브라우저에서 http://localhost:3000 을 열어주세요"
echo "🛑 서버를 중지하려면 Ctrl+C를 누르세요"
echo "================================"
echo ""

npm run dev
