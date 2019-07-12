class List {
 private:
  struct node {
    int value;
    node * pred;
    node * next;
  };
  node * head;
  node * tail;
  
 public:
  List();
  ~List();
  void insert(int);
  void remove(int);
  bool exists(int);
  int count();
  void print();
};
