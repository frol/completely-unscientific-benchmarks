#include <iostream>
#include <memory>

class Treap {
 public:
  bool HasValue(int value);
  void Insert(int value);
  void Erase(int value);

 private:
  struct Node {
    explicit Node(int value) : value(value) {}

    int value;
    int priority = rand();

    std::shared_ptr<Node> left;
    std::shared_ptr<Node> right;
  };

  static void Split(std::shared_ptr<Node>&& input, int value,
                    std::shared_ptr<Node>* less,
                    std::shared_ptr<Node>* greater_or_equal);
  static void Merge(std::shared_ptr<Node>&& less,
                    std::shared_ptr<Node>&& greater,
                    std::shared_ptr<Node>* result);

  std::shared_ptr<Node> root_;
};

inline bool Treap::HasValue(int value) {
  std::shared_ptr<Node> less;
  std::shared_ptr<Node> greater;
  Split(std::move(root_), value, &less, &greater);
  Split(std::move(greater), value + 1, &root_, &greater);
  const bool has_value = root_ != nullptr;
  Merge(std::move(less), std::move(root_), &root_);
  Merge(std::move(root_), std::move(greater), &root_);
  return has_value;
}

inline void Treap::Insert(int value) {
  std::shared_ptr<Node> less;
  std::shared_ptr<Node> greater;
  Split(std::move(root_), value, &less, &greater);
  Split(std::move(greater), value + 1, &root_, &greater);
  if (!root_) root_ = std::make_shared<Node>(value);
  Merge(std::move(less), std::move(root_), &root_);
  Merge(std::move(root_), std::move(greater), &root_);
}

inline void Treap::Erase(int value) {
  std::shared_ptr<Node> less;
  std::shared_ptr<Node> greater;
  Split(std::move(root_), value, &less, &greater);
  Split(std::move(greater), value + 1, &root_, &greater);
  Merge(std::move(less), std::move(greater), &root_);
}

inline void Treap::Split(std::shared_ptr<Node>&& input, int value,
                         std::shared_ptr<Node>* less,
                         std::shared_ptr<Node>* greater_or_equal) {
  if (!input) {
    *less = *greater_or_equal = nullptr;
  } else if (input->value < value) {
    const auto ptr = &input->right;
    *less = std::move(input);
    Split(std::move(*ptr), value, ptr, greater_or_equal);
  } else {
    const auto ptr = &input->left;
    *greater_or_equal = std::move(input);
    Split(std::move(*ptr), value, less, ptr);
  }
}

inline void Treap::Merge(std::shared_ptr<Node>&& less,
                         std::shared_ptr<Node>&& greater,
                         std::shared_ptr<Node>* result) {
  if (!less | !greater) {
    *result = std::move(less ? less : greater);
  } else if (less->priority < greater->priority) {
    const auto ptr = &less->right;
    Merge(std::move(*ptr), std::move(greater), ptr);
    *result = std::move(less);
  } else {
    const auto ptr = &greater->left;
    Merge(std::move(less), std::move(*ptr), ptr);
    *result = std::move(greater);
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
