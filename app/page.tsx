'use client';

import { useState } from 'react';
import './globals.css';

interface NewsItem {
  title: string;
  url: string;
  snippet: string;
}

export default function Home() {
  const [keyword, setKeyword] = useState('');
  const [news, setNews] = useState<NewsItem[]>([]);
  const [summary, setSummary] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [chatMessage, setChatMessage] = useState('');
  const [chatHistory, setChatHistory] = useState<Array<{ role: 'user' | 'bot'; message: string }>>([]);
  const [chatLoading, setChatLoading] = useState(false);
  const [sessionId] = useState(() => Math.random().toString(36).substring(7));

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!keyword.trim()) return;

    setLoading(true);
    setError('');
    setNews([]);
    setSummary('');
    setChatHistory([]);

    try {
      const response = await fetch('/api/search-news', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ keyword }),
      });

      const data = await response.json();

      if (!response.ok) {
        console.error('API 오류:', data);
        throw new Error(data.error || '뉴스 검색에 실패했습니다.');
      }

      if (!data.news || data.news.length === 0) {
        throw new Error('뉴스를 찾을 수 없습니다. 다른 키워드로 시도해주세요.');
      }

      setNews(data.news || []);
      setSummary(data.summary || '');
    } catch (err: any) {
      console.error('검색 오류:', err);
      setError(err.message || '뉴스 검색 중 오류가 발생했습니다. 터미널의 오류 메시지를 확인해주세요.');
    } finally {
      setLoading(false);
    }
  };

  const handleChat = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!chatMessage.trim() || !news.length) return;

    const userMessage = chatMessage;
    setChatMessage('');
    setChatHistory(prev => [...prev, { role: 'user', message: userMessage }]);
    setChatLoading(true);

    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message: userMessage,
          newsData: { news, summary },
          sessionId,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || '챗봇 응답 생성에 실패했습니다.');
      }

      setChatHistory(prev => [...prev, { role: 'bot', message: data.message }]);
    } catch (err: any) {
      setChatHistory(prev => [...prev, { 
        role: 'bot', 
        message: `오류: ${err.message || '응답 생성 중 오류가 발생했습니다.'}` 
      }]);
    } finally {
      setChatLoading(false);
    }
  };

  return (
    <div className="container">
      <div className="header">
        <h1>📰 뉴스 챗봇</h1>
        <p>키워드를 입력하면 관련 뉴스를 검색하고 대화할 수 있습니다</p>
      </div>

      <div className="search-section">
        <form onSubmit={handleSearch} className="search-form">
          <input
            type="text"
            value={keyword}
            onChange={(e) => setKeyword(e.target.value)}
            placeholder="키워드 입력 (예: 인공지능, 기술)"
            className="search-input"
            disabled={loading}
          />
          <button type="submit" className="search-button" disabled={loading}>
            {loading ? '검색 중...' : '검색'}
          </button>
        </form>
        {error && <div className="error">{error}</div>}
      </div>

      {loading && <div className="loading">뉴스를 검색하고 요약하는 중...</div>}

      {news.length > 0 && (
        <>
          <div className="news-section">
            <h2>📋 검색된 뉴스 (10개)</h2>
            <div className="news-list">
              {news.map((item, index) => (
                <div key={index} className="news-item">
                  <div className="news-title">{item.title}</div>
                  {item.url && (
                    <a 
                      href={item.url} 
                      target="_blank" 
                      rel="noopener noreferrer"
                      className="news-link"
                    >
                      {item.url}
                    </a>
                  )}
                  {item.snippet && (
                    <div className="news-snippet">{item.snippet}</div>
                  )}
                </div>
              ))}
            </div>
          </div>

          {summary && (
            <div className="summary-section">
              <h2>📝 뉴스 요약</h2>
              <div className="summary-content">{summary}</div>
            </div>
          )}

          <div className="chatbot-section">
            <h2>💬 뉴스에 대해 질문하기</h2>
            <div className="chat-messages">
              {chatHistory.length === 0 && (
                <div className="message bot">
                  안녕하세요! 검색된 뉴스에 대해 궁금한 점을 물어보세요.
                </div>
              )}
              {chatHistory.map((chat, index) => (
                <div key={index} className={`message ${chat.role}`}>
                  {chat.message}
                </div>
              ))}
              {chatLoading && (
                <div className="message bot">답변을 생성하는 중...</div>
              )}
            </div>
            <form onSubmit={handleChat} className="chat-input-form">
              <input
                type="text"
                value={chatMessage}
                onChange={(e) => setChatMessage(e.target.value)}
                placeholder="질문 입력..."
                className="chat-input"
                disabled={chatLoading}
              />
              <button type="submit" className="chat-button" disabled={chatLoading}>
                {chatLoading ? '전송 중...' : '전송'}
              </button>
            </form>
          </div>
        </>
      )}
    </div>
  );
}
