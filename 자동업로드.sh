#!/bin/bash

echo "🚀 GitHub 자동 업로드"
echo "=================================="
echo ""

# 프로젝트 폴더로 이동
cd "$(dirname "$0")"

# Git 저장소 확인
if [ ! -d ".git" ]; then
    echo "❌ Git 저장소가 초기화되지 않았습니다."
    echo "   먼저 './자동업로드_설정.sh'를 실행하세요."
    exit 1
fi

# 원격 저장소 확인
REMOTE_URL="https://github.com/shpark2507-glitch/-3.git"
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "❌ 원격 저장소가 설정되지 않았습니다."
    echo "   먼저 './자동업로드_설정.sh'를 실행하세요."
    exit 1
fi

# .env.local이 Git에 포함되지 않았는지 확인
if git ls-files 2>/dev/null | grep -q "\.env\.local"; then
    echo "⚠️  .env.local 파일 제거 중..."
    git rm --cached .env.local 2>/dev/null
fi

# 변경사항 확인
echo "📋 변경사항 확인 중..."
CHANGED_FILES=$(git status --porcelain)

if [ -z "$CHANGED_FILES" ]; then
    echo "✅ 커밋할 변경사항이 없습니다."
    exit 0
fi

echo ""
echo "변경된 파일:"
echo "$CHANGED_FILES" | sed 's/^/  /'

# 모든 파일 추가
echo ""
echo "📦 파일 추가 중..."
git add .

# 커밋 메시지 생성
COMMIT_MSG="Update: $(date '+%Y-%m-%d %H:%M:%S') 자동 업데이트"
if [ -n "$1" ]; then
    COMMIT_MSG="$1"
fi

# 커밋
echo ""
echo "💾 커밋 중..."
if git commit -m "$COMMIT_MSG" 2>&1; then
    echo "✅ 커밋 완료: $COMMIT_MSG"
else
    echo "⚠️  커밋 실패 또는 변경사항 없음"
    exit 0
fi

# 브랜치 확인
BRANCH=$(git branch --show-current 2>/dev/null || echo "main")

# 푸시
echo ""
echo "🚀 GitHub에 푸시 중..."
if git push -u origin "$BRANCH" 2>&1; then
    echo ""
    echo "✅ 성공적으로 업로드되었습니다!"
    echo "📝 저장소: $REMOTE_URL"
    echo "🌐 Vercel이 자동으로 재배포를 시작합니다"
    echo ""
    echo "배포 확인: https://3-five-xi.vercel.app"
else
    echo ""
    echo "⚠️  푸시 실패. 다음을 확인하세요:"
    echo "   1. GitHub 인증 확인"
    echo "   2. 저장소 접근 권한 확인"
    echo "   3. 수동 푸시: git push -u origin $BRANCH"
    exit 1
fi

echo ""
echo "완료!"
