#!/bin/bash

echo "🔒 Git 업로드 전 API 키 보안 확인"
echo "=================================="
echo ""

# .env.local 파일이 Git에 추가되지 않았는지 확인
if git ls-files | grep -q "\.env\.local"; then
    echo "❌ 경고: .env.local 파일이 Git에 추가되어 있습니다!"
    echo "   이 파일을 제거해야 합니다."
    git rm --cached .env.local 2>/dev/null
    echo "✅ .env.local 파일을 Git 추적에서 제거했습니다."
else
    echo "✅ .env.local 파일이 Git에 포함되지 않았습니다 (안전)"
fi

# .gitignore 확인
if grep -q "\.env.*local" .gitignore; then
    echo "✅ .gitignore에 .env*.local이 포함되어 있습니다 (안전)"
else
    echo "⚠️  .gitignore에 .env*.local이 없습니다. 추가해야 합니다."
fi

echo ""
echo "📋 Git 상태 확인:"
git status --short

echo ""
echo "⚠️  다음 파일들이 Git에 추가되지 않아야 합니다:"
echo "   - .env.local (API 키 포함)"
echo "   - node_modules/"
echo "   - .next/"
echo ""

# 안전 확인
read -p "계속하시겠습니까? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "취소되었습니다."
    exit 1
fi

echo ""
echo "📦 Git에 파일 추가 중..."
git add .

echo ""
echo "🔍 추가된 파일 확인:"
git status --short

echo ""
echo "⚠️  최종 확인: .env.local 파일이 위 목록에 없어야 합니다!"
echo ""

read -p "커밋하시겠습니까? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git commit -m "Initial commit: 뉴스 챗봇 프로젝트"
    echo ""
    echo "✅ 커밋 완료!"
    echo ""
    echo "다음 단계:"
    echo "1. GitHub/GitLab 등에 원격 저장소 생성"
    echo "2. 다음 명령어로 원격 저장소 연결:"
    echo "   git remote add origin <원격저장소URL>"
    echo "3. 다음 명령어로 푸시:"
    echo "   git push -u origin main"
else
    echo "커밋이 취소되었습니다."
fi
