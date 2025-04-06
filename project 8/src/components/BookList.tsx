import React from 'react';
import { Book } from '../types';
import { BookOpen } from 'lucide-react';

interface BookListProps {
  books: Book[];
  onBorrow: (bookId: string) => void;
  userEmail: string;
}

export const BookList: React.FC<BookListProps> = ({ books, onBorrow, userEmail }) => {
  const groupedBooks = books.reduce((acc, book) => {
    if (!acc[book.series]) {
      acc[book.series] = [];
    }
    acc[book.series].push(book);
    return acc;
  }, {} as Record<string, Book[]>);

  return (
    <div className="space-y-8">
      {Object.entries(groupedBooks).map(([series, seriesBooks]) => (
        <div key={series} className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-2xl font-bold mb-4">{series}</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {seriesBooks.map((book) => (
              <div key={book.id} className="border rounded-lg p-4 hover:shadow-lg transition-shadow">
                <div className="flex items-center gap-2 mb-2">
                  <BookOpen className="w-5 h-5 text-blue-600" />
                  <h3 className="text-lg font-semibold">{book.title}</h3>
                </div>
                <p className="text-gray-600 mb-2">
                  目前等待人數：{book.waitingList.length} 人
                </p>
                <button
                  onClick={() => onBorrow(book.id)}
                  disabled={book.waitingList.includes(userEmail)}
                  className={`w-full px-4 py-2 rounded-md ${
                    book.waitingList.includes(userEmail)
                      ? 'bg-gray-300 cursor-not-allowed'
                      : 'bg-blue-600 hover:bg-blue-700 text-white'
                  }`}
                >
                  {book.waitingList.includes(userEmail) ? '已在等待清單中' : '申請借閱'}
                </button>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
};