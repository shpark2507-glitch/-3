import { NextRequest, NextResponse } from 'next/server';
import { supabase } from '@/lib/supabase';

// 검색 기록 조회
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const limit = parseInt(searchParams.get('limit') || '20');
    const keyword = searchParams.get('keyword');

    let query = supabase
      .from('news_searches')
      .select(`
        id,
        keyword,
        created_at,
        news_articles (
          id,
          title,
          url,
          snippet,
          created_at
        )
      `)
      .order('created_at', { ascending: false })
      .limit(limit);

    // 키워드로 필터링
    if (keyword) {
      query = query.ilike('keyword', `%${keyword}%`);
    }

    const { data, error } = await query;

    if (error) {
      console.error('검색 기록 조회 오류:', error);
      return NextResponse.json(
        { error: '검색 기록을 불러올 수 없습니다: ' + error.message },
        { status: 500 }
      );
    }

    return NextResponse.json({
      searches: data || []
    });

  } catch (error: any) {
    console.error('검색 기록 조회 오류:', error);
    return NextResponse.json(
      { error: '검색 기록 조회 중 오류가 발생했습니다: ' + error.message },
      { status: 500 }
    );
  }
}
