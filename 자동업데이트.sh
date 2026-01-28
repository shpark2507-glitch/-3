#!/bin/bash

echo "🔄 GitHub 저장소 자동 업데이트"
echo "=================================="
echo ""

# 프로젝트 폴더로 이동
cd "$(dirname "$0")"

# Git 저장소 초기화 (이미 있으면 스킵)
if [ ! -d ".git" ]; then
    echo "📦 Git 저장소 초기화 중..."
    git init
fi

# 원격 저장소 확인 및 설정
REMOTE_URL="https://github.com/shpark2507-glitch/-3.git"

if git remote get-url origin >/dev/null 2>&1; then
    CURRENT_URL=$(git remote get-url origin)
    if [ "$CURRENT_URL" != "$REMOTE_URL" ]; then
        echo "🔄 원격 저장소 URL 업데이트 중..."
        git remote set-url origin "$REMOTE_URL"
    else
        echo "✅ 원격 저장소가 이미 올바르게 설정되어 있습니다"
    fi
else
    echo "🔗 원격 저장소 연결 중..."
    git remote add origin "$REMOTE_URL"
fi

# .env.local이 Git에 포함되지 않았는지 확인
if git ls-files | grep -q "\.env\.local"; then
    echo "⚠️  경고: .env.local 파일이 Git에 포함되어 있습니다. 제거 중..."
    git rm --cached .env.local 2>/dev/null
fi

# 변경사항 확인
echo ""
echo "📋 변경사항 확인:"
git status --short

# 모든 파일 추가 (제외된 파일은 .gitignore에 의해 자동 제외)
echo ""
echo "📦 파일 추가 중..."
git add .

# 변경사항이 있는지 확인
if git diff --staged --quiet; then
    echo "✅ 커밋할 변경사항이 없습니다"
else
    echo ""
    echo "💾 커밋 중..."
    git commit -m "Update: 프로젝트 업데이트 $(date '+%Y-%m-%d %H:%M:%S')"
    
    echo ""
    echo "🚀 GitHub에 푸시 중..."
    
    # 브랜치 확인 및 설정
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
    if [ -z "$CURRENT_BRANCH" ]; then
        git checkout -b main
        CURRENT_BRANCH="main"
    fi
    
    # 푸시 실행
    if git push -u origin "$CURRENT_BRANCH" 2>&1; then
        echo ""
        echo "✅ 성공적으로 업데이트되었습니다!"
        echo "📝 저장소: $REMOTE_URL"
    else
        echo ""
        echo "⚠️  푸시 실패. 다음을 확인하세요:"
        echo "   1. GitHub 인증이 되어 있는지 확인"
        echo "   2. 저장소 접근 권한이 있는지 확인"
        echo "   3. 수동으로 푸시: git push -u origin $CURRENT_BRANCH"
    fi
fi

echo ""
echo "완료!"
