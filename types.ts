export interface Book {
  id: string;
  title: string;
  series: string;
  waitingList: string[];
}

export interface User {
  email: string;
  name: string;
}