#!/bin/bash

echo "🚀 GitHub에 업로드하기"
echo "=================================="
echo ""

cd "$(dirname "$0")"

# Git 저장소 초기화
if [ ! -d ".git" ]; then
    echo "📦 Git 저장소 초기화 중..."
    git init
fi

# 원격 저장소 설정
REMOTE_URL="https://github.com/shpark2507-glitch/-3.git"

if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "$REMOTE_URL"
else
    git remote add origin "$REMOTE_URL"
fi

# .env.local 제외 확인
if git ls-files 2>/dev/null | grep -q "\.env\.local"; then
    git rm --cached .env.local 2>/dev/null
fi

# 파일 추가
echo "📦 파일 추가 중..."
git add .

# 커밋
echo "💾 커밋 중..."
git commit -m "Update: Supabase DB 연동 및 뉴스 데이터 관리 기능 추가

- Supabase 클라이언트 설정 추가
- 뉴스 검색 시 자동 DB 저장 기능
- 검색 기록 및 뉴스 기사 조회 API 추가
- 데이터베이스 스키마 SQL 파일 추가
- Supabase 설정 가이드 문서 추가"

# 브랜치 설정
git branch -M main

# 푸시
echo ""
echo "🚀 GitHub에 푸시 중..."
if git push -u origin main 2>&1; then
    echo ""
    echo "✅ 성공적으로 업로드되었습니다!"
    echo "📝 저장소: $REMOTE_URL"
    echo "🌐 Vercel이 자동으로 재배포를 시작합니다"
else
    echo ""
    echo "⚠️  푸시 실패. 다음을 확인하세요:"
    echo "   1. GitHub 인증 확인"
    echo "   2. 저장소 접근 권한 확인"
    echo "   3. 수동 푸시: git push -u origin main"
fi

echo ""
echo "완료!"
