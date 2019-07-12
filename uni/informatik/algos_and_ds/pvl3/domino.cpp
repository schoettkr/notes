#include <iostream>
#include <stdio.h>
using namespace std;

/*
Komplexitaeten:
  Teilaufgabe 1 = O(n)
  Teilaufgabe 2/3 = O(n^2) // erfolgt hier in einem Schritt, das printen von Kreisen als einzelne Aufgabe ansonsten auch O(n)
 */

struct node {
  int left;
  int right;
  bool used;
  node * next;
};

void printList(node *);
void releaseList(node *, int);
void swapLeftRight(node *);
node * findMatch(node *, int);
void printStone(node * stone);

int main(int argc, char ** argv) {
  char * filename = argv[1];
  FILE * fileH = fopen(filename, "r");
  if (!fileH) {
    cout << "Datei konnte nicht gelesen werden" << endl;
    return 0;
  }

  int stoneCount = 0;
  fscanf(fileH, "%d", &stoneCount);
  node * head = NULL;
  node * tail = NULL;
  for (int i = 0; i < stoneCount; i++) {
    node * stone = new node();
    fscanf(fileH, "%d", &(stone->left));
    fscanf(fileH, "%d", &(stone->right));
    if (!head) {
      head = stone;
    }
    if (!tail) {
      tail = stone;
    } else {
      tail->next = stone;
      tail = stone;
    }
  }
  
  fclose(fileH);

  cout << "Liste\n  ";
  printList(head);
  tail->next = head;


  cout << "Kreise\n  ";
  node * headCopy = head;
  int iterations = 0;
  printStone(headCopy);
  headCopy->used = true;
  while (headCopy) {
    if (++iterations >= stoneCount) break;
    node * match = findMatch(headCopy, stoneCount);
    if (match) {
      match->used = true;
      printStone(match);
      headCopy = match;
    } else {
      break;
    }
  }
  cout << endl;

  releaseList(head, stoneCount);
  return 0;
}

void printStone(node * stone) {
  cout << "[" << stone->left << ":" << stone->right << "] ";
}

void printList(node * head) {
  while (head) {
    printStone(head);
    head = head->next;
  }
  cout << endl;
}

void releaseList(node * head, int stones) {
  int iterations = 0;
  while (head) {
    if (++iterations > stones) break;
    node * next = head->next;
    delete head;
    head = next;
  }
}

void swapLeftRight(node * stone) {
  int temp = stone->left;
  stone->left = stone->right;
  stone->right = temp;
}

node * findMatch(node * stone, int stones) {
  int iterations = 0;
  int lval = stone->left;
  int rval = stone->right;
  node * nextStone = stone->next;
  while (nextStone) {
    if (++iterations >= stones) break;
    if (!nextStone->used) {
      if (nextStone->right == rval) {
        swapLeftRight(nextStone);
        return nextStone;
      } else if (nextStone->left == rval) {
        return nextStone;
      } else if (nextStone->left == lval) {
        swapLeftRight(stone);
        return nextStone;
      }
    }
    nextStone = nextStone->next;
  }
  return NULL;
}
