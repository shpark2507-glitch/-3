import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || ''
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || ''

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn('Supabase 환경 변수가 설정되지 않았습니다.')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// 타입 정의
export interface NewsSearch {
  id: string
  keyword: string
  created_at: string
}

export interface NewsArticle {
  id: string
  search_id: string
  title: string
  url: string
  snippet: string
  created_at: string
}
