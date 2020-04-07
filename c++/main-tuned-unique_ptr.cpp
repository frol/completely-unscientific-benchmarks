#include <iostream>
#include <memory>

class Tree
{
public:
    Tree() = default;

    bool hasValue(int x);
    void insert(int x);
    void erase(int x);

private:

    struct Node
    {
        Node(int x): x(x) {}
        Node() {}

        int x = 0;
        int y = rand();

        std::unique_ptr<Node> left;
        std::unique_ptr<Node> right;
    };

    using NodePtr = std::unique_ptr<Node>;

    static NodePtr && merge(NodePtr && lower, NodePtr && greater);
    static NodePtr && merge(NodePtr && lower, NodePtr && equal, NodePtr && greater);
    static void split(NodePtr && orig, NodePtr& lower, NodePtr& greaterOrEqual, int val);
    static void split(NodePtr && orig, NodePtr& lower, NodePtr& equal, NodePtr& greater, int val);

    NodePtr mRoot;
};

bool Tree::hasValue(int x)
{
    NodePtr lower, equal, greater;
    split(std::move(mRoot), lower, equal, greater, x);
    bool res = equal != nullptr;
    mRoot = merge(std::move(lower), std::move(equal), std::move(greater));
    return res;
}

void Tree::insert(int x)
{
    NodePtr lower, equal, greater;
    split(std::move(mRoot), lower, equal, greater, x);
    if(!equal)
        equal = std::make_unique<Node>(x);

    mRoot = merge(std::move(lower), std::move(equal), std::move(greater));
}

void Tree::erase(int x)
{
    NodePtr lower, equal, greater;
    split(std::move(mRoot), lower, equal, greater, x);
    mRoot = merge(std::move(lower), std::move(greater));
}

Tree::NodePtr && Tree::merge(NodePtr && lower, NodePtr && greater)
{
    if(!lower)
        return std::move(greater);

    if(!greater)
        return std::move(lower);

    if(lower->y < greater->y)
    {
        lower->right = merge(std::move(lower->right), std::move(greater));
        return std::move(lower);
    }
    else
    {
        greater->left = merge(std::move(lower), std::move(greater->left));
        return std::move(greater);
    }
}

Tree::NodePtr && Tree::merge(NodePtr && lower, NodePtr && equal, NodePtr && greater)
{
    return merge(merge(std::move(lower), std::move(equal)), std::move(greater));
}

void Tree::split(NodePtr && orig, NodePtr& lower, NodePtr& greaterOrEqual, int val)
{
    if(!orig)
    {
        lower = nullptr;
        greaterOrEqual = nullptr;
        return;
    }

    if(orig->x < val)
    {
        lower = std::move(orig);
        split(std::move(lower->right), lower->right, greaterOrEqual, val);
    }
    else
    {
        greaterOrEqual = std::move(orig);
        split(std::move(greaterOrEqual->left), lower, greaterOrEqual->left, val);
    }
}

void Tree::split(NodePtr && orig, NodePtr& lower, NodePtr& equal, NodePtr& greater, int val)
{
    NodePtr equalOrGreater;
    split(std::move(orig), lower, equalOrGreater, val);
    split(std::move(equalOrGreater), equal, greater, val + 1);
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
