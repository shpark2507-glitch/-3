#!/bin/bash

echo "🔧 GitHub 자동 업데이트 설정"
echo "=================================="
echo ""

# 프로젝트 폴더로 이동
cd "$(dirname "$0")"

# Git 저장소 초기화
if [ ! -d ".git" ]; then
    echo "📦 Git 저장소 초기화 중..."
    git init
    echo "✅ Git 저장소 초기화 완료"
else
    echo "✅ Git 저장소가 이미 존재합니다"
fi

# 원격 저장소 설정
REMOTE_URL="https://github.com/shpark2507-glitch/-3.git"

if git remote get-url origin >/dev/null 2>&1; then
    CURRENT_URL=$(git remote get-url origin)
    if [ "$CURRENT_URL" != "$REMOTE_URL" ]; then
        echo "🔄 원격 저장소 URL 업데이트 중..."
        git remote set-url origin "$REMOTE_URL"
        echo "✅ 원격 저장소 URL 업데이트 완료"
    else
        echo "✅ 원격 저장소가 이미 올바르게 설정되어 있습니다"
    fi
else
    echo "🔗 원격 저장소 연결 중..."
    git remote add origin "$REMOTE_URL"
    echo "✅ 원격 저장소 연결 완료"
fi

# .env.local이 Git에 포함되지 않았는지 확인
if git ls-files 2>/dev/null | grep -q "\.env\.local"; then
    echo "⚠️  .env.local 파일 제거 중..."
    git rm --cached .env.local 2>/dev/null
fi

# 브랜치 설정
BRANCH=$(git branch --show-current 2>/dev/null || echo "")
if [ -z "$BRANCH" ]; then
    git checkout -b main 2>/dev/null || git branch -M main 2>/dev/null
    BRANCH="main"
fi

echo ""
echo "✅ 설정 완료!"
echo ""
echo "📋 다음 명령어로 수동 업로드:"
echo "   ./자동업로드.sh"
echo ""
echo "또는:"
echo "   git add ."
echo "   git commit -m 'Update: 변경사항'"
echo "   git push origin main"
