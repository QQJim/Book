import React, { useState, useEffect } from 'react';
import { Toaster, toast } from 'react-hot-toast';
import emailjs from '@emailjs/browser';
import { LoginForm } from './components/LoginForm';
import { BookList } from './components/BookList';
import { User, Book } from './types';
import { supabase } from './lib/supabase';

function App() {
  const [user, setUser] = useState<User | null>(null);
  const [books, setBooks] = useState<Book[]>([]);

  useEffect(() => {
    fetchBooks();
  }, []);

  const fetchBooks = async () => {
    try {
      const { data: booksData, error: booksError } = await supabase
        .from('books')
        .select('*');

      if (booksError) throw booksError;

      const { data: waitingListData, error: waitingError } = await supabase
        .from('waiting_list')
        .select('*');

      if (waitingError) throw waitingError;

      const booksWithWaitingList = booksData.map(book => ({
        ...book,
        waitingList: waitingListData
          .filter(item => item.book_id === book.id)
          .map(item => item.user_email)
      }));

      setBooks(booksWithWaitingList);
    } catch (error) {
      console.error('Error fetching data:', error);
      toast.error('載入書籍資料時發生錯誤');
    }
  };

  const handleLogin = (userData: User) => {
    setUser(userData);
    toast.success(`歡迎, ${userData.name}!`);
  };

  const handleBorrow = async (bookId: string) => {
    if (!user) return;

    try {
      const { error } = await supabase
        .from('waiting_list')
        .insert([
          { book_id: bookId, user_email: user.email }
        ]);

      if (error) throw error;

      // 重新獲取最新的書籍資料
      await fetchBooks();

      // 發送郵件給使用者
      await emailjs.send(
        'service_mlljvjl',
        'template_user',
        {
          user_email: user.email,
          user_name: user.name,
          book_title: books.find(b => b.id === bookId)?.title,
          queue_position: books.find(b => b.id === bookId)?.waitingList.length || 1,
        }
      );

      // 發送郵件給管理員
      await emailjs.send(
        'service_mlljvjl',
        'template_admin',
        {
          admin_email: '8269102st.tc.edu.tw',
          user_name: user.name,
          book_title: books.find(b => b.id === bookId)?.title,
        }
      );

      toast.success('借閱申請已送出！');
    } catch (error) {
      console.error('Error:', error);
      toast.error('借閱申請失敗');
    }
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <Toaster position="top-right" />
      {!user ? (
        <LoginForm onLogin={handleLogin} />
      ) : (
        <div className="container mx-auto py-8 px-4">
          <div className="mb-8">
            <h1 className="text-3xl font-bold text-center mb-2">線上借書系統</h1>
            <p className="text-center text-gray-600">
              歡迎, {user.name} ({user.email})
            </p>
          </div>
          <BookList
            books={books}
            onBorrow={handleBorrow}
            userEmail={user.email}
          />
        </div>
      )}
    </div>
  );
}

export default App;