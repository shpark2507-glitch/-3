#!/bin/bash

echo "🚀 자동 푸시 실행 중..."
echo "=================================="

cd /Users/parkkun/Desktop/챗봇

# 현재 상태 확인
echo ""
echo "📋 현재 상태:"
git status

echo ""
echo "🔄 GitHub에 푸시 중..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 성공적으로 업로드되었습니다!"
    echo ""
    echo "🌐 확인:"
    echo "   GitHub: https://github.com/shpark2507-glitch/-3"
    echo "   Vercel: https://3-five-xi.vercel.app (배포 대기 중...)"
else
    echo ""
    echo "❌ 푸시 실패"
    echo ""
    echo "💡 해결 방법:"
    echo "1. GitHub Personal Access Token 생성:"
    echo "   https://github.com/settings/tokens/new"
    echo ""
    echo "2. 권한 선택: repo 체크"
    echo ""
    echo "3. 토큰 복사 후 다음 명령어 실행:"
    echo "   git remote set-url origin https://토큰@github.com/shpark2507-glitch/-3.git"
    echo ""
    echo "4. 다시 푸시:"
    echo "   git push origin main"
fi
