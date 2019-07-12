#include <iostream>
#include <stack>
using namespace std;
/* Baum
   


           7
   10              1
9    34          8
    7   25         
       3

 */

/*
pre order Wurzel - Links - Rechts
7 10 9 34 7 25 3 1 8

in order Links - Wurzel - Rechts
9 10 7 34 3 25 7 8 1

post order Links - Rechts - Wurzel
9 7 3 25 34 10 8 1 7

TechieDelight, GeeksforGeeks
*/

struct node {
  int data;
  node * left;
  node * right;
};

int countLeaves(node * root) {
  if (root == 0) return 0;
  else if (!root->left && !root->right) return 1;
  else return countLeaves(root->left) + countLeaves(root->right);
}

int height(node * root) {
  if (root == 0) return 0;
  else {
    int left = height(root->left);
    int right = height(root->right);
    if (left <= right ) return 1 + right;
    else return 1 + left;
  }
}

int countLeftNodes(node * root) {
  if (root == 0) return 0;
  else if (root->left) {
    return 1 + countLeftNodes(root->left) + countLeftNodes(root->right);
  } else {
    return countLeftNodes(root->right);
  }
  // int count = 0;
  // if (root->left) count += 1;
  // count += countLeftNodes(root->left);
  // count += countLeftNodes(root->right);
  // return count;
}

void mirror(node * root) {
  if (root)  {
    node * temp = root->left;
    root->left = root->right;
    root->right = temp;
    mirror(root->left);
    mirror(root->right);
  }
}

void inorderIterative(node * root) {
  stack<node *> stack;
  node * current = root;
  while (!stack.empty() || current != 0) {
    if (current != 0) {
      stack.push(current);
      current = current->left;
    } else {
      current = stack.top();
      stack.pop();
      printf("%d ", current->data);
      current = current->right;
    }
  }
}

int main() {
  return 0;
}
