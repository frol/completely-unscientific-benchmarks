#include <iostream>
#include <memory>

class Tree
{
public:
    Tree() = default;
    ~Tree()
    {
        delete mRoot;
    }

    bool hasValue(int x);
    void insert(int x);
    void erase(int x);

private:
    struct Node
    {
        Node(int x): x(x) {}
        Node() {}
        ~Node()
        {
            delete left;
            delete right;
        }

        int x = 0;
        int y = rand();

        Node* left = nullptr;
        Node* right = nullptr;
    };

    using NodePtr = Node*;

    static void merge(NodePtr lower, NodePtr greater, NodePtr& merged);
    static void merge(NodePtr lower, NodePtr equal, NodePtr greater, NodePtr& merged);
    static void split(NodePtr orig, NodePtr& lower, NodePtr& greaterOrEqual, int val);
    static void split(NodePtr orig, NodePtr& lower, NodePtr& equal, NodePtr& greater, int val);
    static void clear(NodePtr node);

    NodePtr mRoot = nullptr;
};

bool Tree::hasValue(int x)
{
    NodePtr lower, equal, greater;
    split(mRoot, lower, equal, greater, x);
    bool res = equal != nullptr;
    merge(lower, equal, greater, mRoot);
    return res;
}

void Tree::insert(int x)
{
    NodePtr lower, equal, greater;
    split(mRoot, lower, equal, greater, x);
    if(!equal)
        equal = new Node(x);

    merge(lower, equal, greater, mRoot);
}

void Tree::erase(int x)
{
    NodePtr lower, equal, greater;
    split(mRoot, lower, equal, greater, x);
    merge(lower, greater, mRoot);
    delete equal;
}

void Tree::merge(NodePtr lower, NodePtr greater, NodePtr& merged)
{
    if(!lower)
    {
        merged = greater;
        return;
    }

    if(!greater)
    {
        merged = lower;
        return;
    }

    if(lower->y < greater->y)
    {
        merged = lower;
        merge(merged->right, greater, merged->right);
    }
    else
    {
        merged = greater;
        merge(lower, merged->left, merged->left);
    }
}

void Tree::merge(NodePtr lower, NodePtr equal, NodePtr greater, NodePtr& merged)
{
    merge(lower, equal, merged);
    merge(merged, greater, merged);
}

void Tree::split(NodePtr orig, NodePtr& lower, NodePtr& greaterOrEqual, int val)
{
    if(!orig)
    {
        lower = greaterOrEqual = nullptr;
        return;
    }

    if(orig->x < val)
    {
        lower = orig;
        split(lower->right, lower->right, greaterOrEqual, val);
    }
    else
    {
        greaterOrEqual = orig;
        split(greaterOrEqual->left, lower, greaterOrEqual->left, val);
    }
}

void Tree::split(NodePtr orig, NodePtr& lower, NodePtr& equal, NodePtr& greater, int val)
{
    NodePtr equalOrGreater;
    split(orig, lower, equalOrGreater, val);
    split(equalOrGreater, equal, greater, val + 1);
}

int main()
{
    srand(time(0));

    Tree tree;

    int cur = 5;
    int res = 0;

    for(int i = 1; i < 1000000; i++)
    {
        int mode = i % 3;
        cur = (cur * 57 + 43) % 10007;
        if(mode == 0)
        {
            tree.insert(cur);
        }
        else if(mode == 1)
        {
            tree.erase(cur);
        }
        else if(mode == 2)
        {
            res += tree.hasValue(cur);
        }
    }
    std::cout << res << std::endl;
    return 0;
}
