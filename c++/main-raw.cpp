#include <iostream>
#include <memory>

class Treap {
 public:
  ~Treap() { delete root_; }

  bool HasValue(int value);
  void Insert(int value);
  void Erase(int value);

 private:
  struct Node {
    explicit Node(int value) : value(value) {}

    ~Node() {
      delete left;
      delete right;
    }

    int value;
    int priority = rand();

    Node* left = nullptr;
    Node* right = nullptr;
  };

  static void Split(Node* input, int value, Node** less,
                    Node** greater_or_equal);
  static void Merge(Node* less, Node* greater, Node** result);

  Node* root_ = nullptr;
};

inline bool Treap::HasValue(int value) {
  Node* less;
  Node* greater;
  Split(root_, value, &less, &greater);
  Split(greater, value + 1, &root_, &greater);
  const bool has_value = root_ != nullptr;
  Merge(less, root_, &root_);
  Merge(root_, greater, &root_);
  return has_value;
}

inline void Treap::Insert(int value) {
  Node* less;
  Node* greater;
  Split(root_, value, &less, &greater);
  Split(greater, value + 1, &root_, &greater);
  if (!root_) root_ = new Node(value);
  Merge(less, root_, &root_);
  Merge(root_, greater, &root_);
}

inline void Treap::Erase(int value) {
  Node* less;
  Node* greater;
  Split(root_, value, &less, &greater);
  Split(greater, value + 1, &root_, &greater);
  delete root_;
  Merge(less, greater, &root_);
}

inline void Treap::Split(Node* input, int value, Node** less,
                         Node** greater_or_equal) {
  if (!input) {
    *less = *greater_or_equal = nullptr;
  } else if (input->value < value) {
    *less = input;
    Split(input->right, value, &input->right, greater_or_equal);
  } else {
    *greater_or_equal = input;
    Split(input->left, value, less, &input->left);
  }
}

inline void Treap::Merge(Node* less, Node* greater, Node** result) {
  if (!less | !greater) {
    *result = less ? less : greater;
  } else if (less->priority < greater->priority) {
    *result = less;
    Merge(less->right, greater, &less->right);
  } else {
    *result = greater;
    Merge(less, greater->left, &greater->left);
  }
}

int main() {
  srand(time(0));

  Treap treap;
  int current = 5;
  int result = 0;
  for (int i = 1; i < 1000000; ++i) {
    const int mode = i % 3;
    current = (current * 57 + 43) % 10007;
    if (mode == 0) {
      treap.Insert(current);
    } else if (mode == 1) {
      treap.Erase(current);
    } else if (mode == 2) {
      result += treap.HasValue(current);
    }
  }
  std::cout << result;
  return 0;
}
