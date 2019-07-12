// #include <List.h>
#include <iostream>
using namespace std;
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

List::List() {
  head = NULL;
  tail = NULL;
}

List::~List() {
  node * temp = head;
  while (temp) {
    temp = temp->next;
    delete head;
    head = temp;
  }
}

void List::insert(int v) {
  node * newNode = new node;
  // node * newNode; // Musterloesung
  newNode->value = v;
  newNode->pred = tail;
  newNode->next = NULL;
  if (!head) {
    head = newNode;
  }
  if (tail) {
    tail->next = newNode;
  }
  tail = newNode;
}

void List::print() {
  node * current = head;
  while (current)  {
    // cout << current->value;
    printf("%d ", current->value);
    current = current->next;
  }
  printf("\n");
}

void List::remove(int value) {
  node * current = head;
  while (current) {
    if (current->value == value) {
      // Alternative 1
      // (current->pred)->next = current->next;
      // (current->next)->pred = current->pred;

      // Alternative 2
      node * pre = current->pred;
      node * next = current->next;
      if (pre) {
        pre->next = current->next;
      }
      if (next) {
        next->pred = current->pred;
      }

      if (current == head) {
        // next->pred = NULL; // HMMM..?!
        head = next;
      }
      if (current == tail) {
        // pre->next = tail;  // HMMM..?!
        tail = pre;
      }

      delete current;
      // break; // Alle vorkommenden Elemente werden geloescht
    }
    current = current->next;
  }
}

bool List::exists(int value) {
  node * current = head;
  while (current && (current->value != value)) {
    current = current->next;
  }
  return current;
}

int List::count() {
  int count = 0;
  node * current = head;
  while (current) {
    count++;
    current = current->next;
  }
  return count;
}

int main() {
  List l = List();
  l.insert(5);
  l.insert(6);
  l.insert(7);
  l.insert(8);
  l.print();
  cout << l.count() << endl;
  l.remove(5);
  l.remove(8);
  l.print();
  cout << l.exists(6) << endl;
  cout << l.exists(8) << endl;
  cout << l.count() << endl;
}
