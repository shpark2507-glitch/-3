#!/bin/bash

echo "🚀 모바일 반응형 디자인 배포 업데이트"
echo "=================================="
echo ""

# 프로젝트 폴더로 이동
cd "$(dirname "$0")"

# Git 저장소 초기화
if [ ! -d ".git" ]; then
    echo "📦 Git 저장소 초기화 중..."
    git init
fi

# 원격 저장소 설정
REMOTE_URL="https://github.com/shpark2507-glitch/-3.git"

if git remote get-url origin >/dev/null 2>&1; then
    CURRENT_URL=$(git remote get-url origin)
    if [ "$CURRENT_URL" != "$REMOTE_URL" ]; then
        echo "🔄 원격 저장소 URL 업데이트 중..."
        git remote set-url origin "$REMOTE_URL"
    fi
else
    echo "🔗 원격 저장소 연결 중..."
    git remote add origin "$REMOTE_URL"
fi

# .env.local이 Git에 포함되지 않았는지 확인
if git ls-files | grep -q "\.env\.local"; then
    echo "⚠️  .env.local 파일 제거 중..."
    git rm --cached .env.local 2>/dev/null
fi

# 변경사항 확인
echo ""
echo "📋 변경된 파일:"
git status --short

# 모든 파일 추가
echo ""
echo "📦 파일 추가 중..."
git add .

# 커밋
echo ""
echo "💾 커밋 중..."
git commit -m "Update: 모바일 반응형 디자인 적용

- 모바일 화면 최적화
- 터치 친화적 버튼 크기
- 반응형 레이아웃 (모바일/태블릿/데스크톱)
- Viewport 메타 태그 추가
- iOS 스크롤 최적화
- 텍스트 가독성 개선"

# 브랜치 설정
BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
if [ -z "$BRANCH" ]; then
    git checkout -b main
    BRANCH="main"
fi

# 푸시
echo ""
echo "🚀 GitHub에 푸시 중..."
if git push -u origin "$BRANCH" 2>&1; then
    echo ""
    echo "✅ 성공적으로 배포되었습니다!"
    echo "📝 저장소: $REMOTE_URL"
    echo "🌐 Vercel이 자동으로 재배포를 시작합니다"
else
    echo ""
    echo "⚠️  푸시 실패. 다음을 확인하세요:"
    echo "   1. GitHub 인증 확인"
    echo "   2. 저장소 접근 권한 확인"
    echo "   3. 수동 푸시: git push -u origin $BRANCH"
fi

echo ""
echo "완료!"
