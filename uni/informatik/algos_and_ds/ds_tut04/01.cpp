#include <iostream>
using namespace std;

struct node {
  int info;
  node* next;
};

void insertSorted(node *head, int val) {
  if (!head) {
    head = new node;
    head->info = val;
    head->next = NULL;
    return;
  }
  while(head->next->info < val) {
    head = head->next;
  }
  node* newNode = new node;
  newNode->info = val;
  newNode->next = head->next;
  head->next = newNode;
}

node* search(node *head, int val) {
  while (head) {
    if (head->info == val) {
      return head;
    }
    head = head->next;
  }
  return NULL;
}

node* searchRecursive(node *current, int val) {
  if (current == NULL) return NULL;
  if (current->info == val) return current;
  return searchRecursive(current->next, val);
}


// Todo: Musterloesung startet am Head
void insertAtTail(node *&tail, int value) {
  node *newNode = new node;
  newNode->info = value;
  newNode->next = NULL;
  tail->next = newNode;
  tail = newNode;
}
// With pointer to pointer:
// void insertAtTail(node **tail, int value) {
//   node *newNode = new node;
//   newNode->info = value;
//   newNode->next = NULL;
//   (*tail)->next = newNode;
//   *tail = newNode;
// }

void insertAtHead(node *&head, int value) {
  node* newNode = new node;
  newNode->info = value;
  newNode->next = head;
  head = newNode;
}

// node* insertAtHead(node *head, int value) {
//   node *newNode = new node;
//   newNode->info = value;
//   newNode->next = head;
//   return newNode;
// }

void writeList(node *head);
int main() {
  
  node a = {5};
  node b = {6};
  node c = {8};
  a.next = &b;
  b.next = &c;

  node *head = &a;
  // node *tail = &c;
  insertSorted(NULL, 7);

  // cout << search(head, 7) << endl;
  // cout << searchRecursive(head, 7) << endl;
  // cout << &c << endl;

  // insertAtHead(head, 10);
  // insertAtTail(tail, 8);

  writeList(head);

  return 0;
}

// Alternative:
void writeList(node *head) {
  while (head) {
    cout << head->info << endl;
    head = head->next;
  }
}
// void writeList(node *head) {
//   node *current = head;
//   while (current) {
//     cout << current->info << endl;
//     current = current->next;
//   }
// }
