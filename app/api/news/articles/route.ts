import { NextRequest, NextResponse } from 'next/server';
import { supabase } from '@/lib/supabase';

// 뉴스 기사 조회
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const limit = parseInt(searchParams.get('limit') || '50');
    const searchId = searchParams.get('search_id');
    const keyword = searchParams.get('keyword');

    let query = supabase
      .from('news_articles')
      .select(`
        id,
        title,
        url,
        snippet,
        created_at,
        news_searches (
          id,
          keyword,
          created_at
        )
      `)
      .order('created_at', { ascending: false })
      .limit(limit);

    // 검색 ID로 필터링
    if (searchId) {
      query = query.eq('search_id', searchId);
    }

    // 키워드로 필터링 (검색 키워드 기준)
    if (keyword) {
      query = query.ilike('news_searches.keyword', `%${keyword}%`);
    }

    const { data, error } = await query;

    if (error) {
      console.error('뉴스 기사 조회 오류:', error);
      return NextResponse.json(
        { error: '뉴스 기사를 불러올 수 없습니다: ' + error.message },
        { status: 500 }
      );
    }

    return NextResponse.json({
      articles: data || []
    });

  } catch (error: any) {
    console.error('뉴스 기사 조회 오류:', error);
    return NextResponse.json(
      { error: '뉴스 기사 조회 중 오류가 발생했습니다: ' + error.message },
      { status: 500 }
    );
  }
}
