using System;

namespace Benchmark {
    sealed class Node {
        public static Random random = new Random();

        int x;
        int y = random.Next();
        Node left, right;

        public Node(int x)
            => this.x = x;

        public static Node merge(Node lower, Node greater) {
            if (lower == null)
                return greater;
            else if (greater == null)
                return lower;
            else if (lower.y < greater.y) {
                lower.right = merge(lower.right, greater);
                return lower;
            } else {
                greater.left = merge(lower, greater.left);
                return greater;
            }
        }

        public static (Node first, Node second) splitBinary(Node orig, int value) {
            if (orig == null)
                return default;
            else if (orig.x < value) {
                var (first, second) = splitBinary(orig.right, value);
                orig.right = first;
                return (orig, second);
            } else {
                var (first, second) = splitBinary(orig.left, value);
                orig.left = second;
                return (first, orig);
            }
        }

        public static Node merge(Node lower, Node equal, Node greater)
            => merge(merge(lower, equal), greater);

        public static (Node lower, Node equal, Node greater) split(Node orig, int value) {
            var lowerOther = splitBinary(orig, value);
            var equalGreater = splitBinary(lowerOther.second, value + 1);
            return (lowerOther.first, equalGreater.first, equalGreater.second);
        }
    }

    sealed class Tree {
        Node mRoot;

        public bool hasValue(int x) {
            var (lower, equal, greater) = Node.split(mRoot, x);
            mRoot = Node.merge(lower, equal, greater);
            return equal != null;
        }

        public void insert(int x) {
            var (lower, equal, greater) = Node.split(mRoot, x);
            mRoot = Node.merge(lower, equal ?? new Node(x), greater);
        }

        public void erase(int x) {
            var splited = Node.split(mRoot, x);
            mRoot = Node.merge(splited.lower, splited.greater);
        }
    }

    class Program {
        static void Main() {
            var tree = new Tree();
            var cur = 5;
            var res = 0;

            for (var i = 1; i < 1000000; i++) {
                var a = i % 3;
                cur = (cur * 57 + 43) % 10007;
                if (a == 0) {
                    tree.insert(cur);
                } else if (a == 1) {
                    tree.erase(cur);
                } else if (a == 2) {
                    if (tree.hasValue(cur))
                        res++;
                }
            }
            Console.WriteLine(res);
        }
    }
}
