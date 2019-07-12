#include <iostream>
using namespace std;


struct node {
  int info;
  node *next;
};

void removeFirst(node *&head); 
// void removeRecursive(node *pos, node *pred, int val);
void writeList(node *head);
void remove(node *&head, int val);

// Musterloesung
node* removeRec(node *head, int value) {
  if (head) {
    if (head->info == value) {
      node *temp = head;
      head = head->next;
      delete temp;
    }
  } else {
    head->next = removeRec(head->next, value);
  }
  return head;
}

node* mirror(node *root) {
  // neue liste anlegen und immer head->next am head der neuen liste einfuegen
  // muster
  node *res = 0;
  while (root != 0) {
    node *n = root; // Kopf alte Liste sichern
    root = root->next; // aushaengen aus alter Liste
    n->next = res;
    res = n;
  }
  return res;
}

bool getMin(node *head, int &minVal) {
  if (head) {
    int min = head->info;
    while (head) {
      if (head->info < min) min = head->info;
      head = head->next;
    }
  }
  minVal = 1;
  return 1;
}

node* sortList() {
  // nutze min funktion um min wert zu holen und entferne min element bis liste leer und anfuegen
}

int main() {

  node a, b, c, d;
  a.info = 1;
  a.next = &b;
  b.info = 2;
  b.next = &c;
  c.info = 3;
  c.next = &d;
  d.info = -4;
  d.next = NULL;
  node *head = &a;
  // head = NULL;
  // writeList(head);

  // removeFirst(head);
  // remove(head, 2);
  // node *pre = NULL;
  // removeRecursive(head, pre, 2);
  // removeRec(head, 2);
  // mirror(head);
  // writeList(head);

  int min = 0;
  getMin(head, min);
  cout << min << endl;

  return 0;
}

void removeFirst(node *&head) {
  if (head) {
    node *temp = head;
    head = head->next;
    return;
    delete temp;
  }
}

void remove(node *&head, int val) {
  node *pos = head;
  node *pred = 0;
  while (pos && pos->info != val) {
    pred = pos;
    pos = pos->next;
  }
  if (pos->info == val) {
    if (!pred) head = head->next;
    else pred->next = pos->next;
    // delete pos; // war in musterloesung des tuts aber macht kein sinn
  }
}


// void removeRecursive(node *pos, node *pred, int val) {
//   if (!pos) return;
//   if (pos->info == val) {
//     if (!pred) pos = pos->next;
//     else pred->next = pos->next;
//     // delete pos; // war in musterloesung des tuts aber macht kein sinn
//     return;
//   } else {
//     removeRecursive(pos->next, pos, val);
//   }
// }

void writeList(node *head) {
  while (head) {
    cout << head->info << endl;
    head = head->next;
  }
}
