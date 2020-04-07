#include <iostream>
#include <memory>

struct Node {
  explicit Node(int value) : value(value) {}

  int value;
  int priority = rand();

  std::shared_ptr<Node> left;
  std::shared_ptr<Node> right;
};

inline std::tuple<std::shared_ptr<Node>, std::shared_ptr<Node>> SplitBinary(
    std::shared_ptr<Node>&& input, int value) {
  if (!input) {
    return std::make_tuple(nullptr, nullptr);
  } else if (input->value < value) {
    auto [less, greater] = SplitBinary(std::move(input->right), value);
    input->right = std::move(less);
    return std::make_tuple(std::move(input), std::move(greater));
  } else {
    auto [less, greater] = SplitBinary(std::move(input->left), value);
    input->left = std::move(greater);
    return std::make_tuple(std::move(less), std::move(input));
  }
}

inline std::tuple<std::shared_ptr<Node>, std::shared_ptr<Node>,
                  std::shared_ptr<Node>>
Split(std::shared_ptr<Node>&& input, int value) {
  auto [less, greater_or_equal] = SplitBinary(std::move(input), value);
  auto [equal, greater] = SplitBinary(std::move(greater_or_equal), value + 1);
  return std::make_tuple(std::move(less), std::move(equal), std::move(greater));
}

inline std::shared_ptr<Node>&& Merge(std::shared_ptr<Node>&& less,
                                     std::shared_ptr<Node>&& greater) {
  if (!less | !greater) {
    return std::move(less ? less : greater);
  } else if (less->priority < greater->priority) {
    less->right = Merge(std::move(less->right), std::move(greater));
    return std::move(less);
  } else {
    greater->left = Merge(std::move(less), std::move(greater->left));
    return std::move(greater);
  }
}

inline std::shared_ptr<Node>&& Merge(std::shared_ptr<Node>&& less,
                                     std::shared_ptr<Node>&& equal,
                                     std::shared_ptr<Node>&& greater) {
  return Merge(Merge(std::move(less), std::move(equal)), std::move(greater));
}

class Treap {
 public:
  bool HasValue(int value) {
    auto [less, equal, greater] = Split(std::move(root_), value);
    const bool has_value = equal != nullptr;
    root_ = Merge(std::move(less), std::move(equal), std::move(greater));
    return has_value;
  }

  void Insert(int value) {
    auto [less, equal, greater] = Split(std::move(root_), value);
    if (!equal) equal = std::make_shared<Node>(value);
    root_ = Merge(std::move(less), std::move(equal), std::move(greater));
  }

  void Erase(int value) {
    auto [less, equal, greater] = Split(std::move(root_), value);
    root_ = Merge(std::move(less), std::move(greater));
  }

 private:
  std::shared_ptr<Node> root_;
};

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
  std::cout << result << std::endl;
  return 0;
}
