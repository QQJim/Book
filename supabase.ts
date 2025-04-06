export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      books: {
        Row: {
          id: string
          title: string
          series: string
          created_at: string
        }
        Insert: {
          id: string
          title: string
          series: string
          created_at?: string
        }
        Update: {
          id?: string
          title?: string
          series?: string
          created_at?: string
        }
      }
      waiting_list: {
        Row: {
          id: string
          book_id: string
          user_email: string
          created_at: string
        }
        Insert: {
          id?: string
          book_id: string
          user_email: string
          created_at?: string
        }
        Update: {
          id?: string
          book_id?: string
          user_email?: string
          created_at?: string
        }
      }
    }
  }
}