import { NextRequest, NextResponse } from 'next/server';
import { GoogleGenerativeAI } from '@google/generative-ai';

// 대화 히스토리를 저장 (실제 프로덕션에서는 데이터베이스 사용 권장)
const conversationHistory: { [key: string]: any[] } = {};

export async function POST(request: NextRequest) {
  try {
    const { message, newsData, sessionId } = await request.json();

    if (!message) {
      return NextResponse.json(
        { error: '메시지가 필요합니다.' },
        { status: 400 }
      );
    }

    const apiKey = process.env.NEXT_PUBLIC_GEMINI_API_KEY;
    if (!apiKey) {
      return NextResponse.json(
        { error: 'Gemini API 키가 설정되지 않았습니다.' },
        { status: 500 }
      );
    }

    const genAI = new GoogleGenerativeAI(apiKey);
    
    // 최신 Gemini Flash 모델 사용 시도
    let model;
    try {
      // 최신 모델 시도: gemini-2.5-flash
      model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });
    } catch (e) {
      try {
        // 대안: gemini-2.0-flash
        model = genAI.getGenerativeModel({ model: 'gemini-2.0-flash' });
      } catch (e2) {
        try {
          // 대안: gemini-1.5-flash-latest
          model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash-latest' });
        } catch (e3) {
          // 최종 대안: gemini-1.5-flash (안정적인 기본 모델)
          model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
        }
      }
    }

    // 세션별 히스토리 관리
    const sessionKey = sessionId || 'default';
    if (!conversationHistory[sessionKey]) {
      conversationHistory[sessionKey] = [];
    }

    // 뉴스 컨텍스트를 포함한 프롬프트 생성
    let contextPrompt = '';
    if (newsData && newsData.news && newsData.summary) {
      contextPrompt = `
다음은 사용자가 검색한 뉴스 정보입니다:

뉴스 요약:
${newsData.summary}

뉴스 목록:
${JSON.stringify(newsData.news, null, 2)}

이 뉴스 정보를 바탕으로 사용자의 질문에 답변해주세요. 뉴스 내용과 관련된 질문이면 구체적으로 답변하고, 관련이 없는 질문이면 정중하게 설명해주세요.
`;
    }

    // 대화 히스토리 추가
    conversationHistory[sessionKey].push({
      role: 'user',
      parts: [{ text: message }]
    });

    // 전체 프롬프트 구성
    const fullPrompt = `
${contextPrompt}

대화 히스토리:
${conversationHistory[sessionKey].slice(-5).map((msg: any) => 
  msg.role === 'user' ? `사용자: ${msg.parts[0].text}` : `챗봇: ${msg.parts[0].text}`
).join('\n')}

사용자: ${message}
챗봇: 
`;

    const result = await model.generateContent(fullPrompt);
    const response = await result.response;
    const botMessage = response.text();

    // 봇 응답을 히스토리에 추가
    conversationHistory[sessionKey].push({
      role: 'model',
      parts: [{ text: botMessage }]
    });

    // 히스토리 크기 제한 (최근 10개만 유지)
    if (conversationHistory[sessionKey].length > 10) {
      conversationHistory[sessionKey] = conversationHistory[sessionKey].slice(-10);
    }

    return NextResponse.json({
      message: botMessage
    });

  } catch (error: any) {
    console.error('챗봇 오류:', error);
    return NextResponse.json(
      { error: '챗봇 응답 생성 중 오류가 발생했습니다: ' + error.message },
      { status: 500 }
    );
  }
}
