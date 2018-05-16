import std.stdio;
import std.random;

private struct Node
{
    int x = 0;
    int y = 0;

    this(int x)
    {
        this.x = x;
        y = uniform!int();
    }

    Node* left = null;
    Node* right = null;
}

struct Tree
{
    bool hasValue(int x)
    {
        Node* lower, equal, greater;
        split(mRoot, lower, equal, greater, x);
        bool res = equal != null;
        mRoot = merge(lower, equal, greater);
        return res;
    }

    void insert(int x)
    {
        Node* lower, equal, greater;
        split(mRoot, lower, equal, greater, x);
        if(!equal)
            equal = new Node(x);

        mRoot = merge(lower, equal, greater);
    }

    void erase(int x)
    {
        Node* lower, equal, greater;
        split(mRoot, lower, equal, greater, x);
        mRoot = merge(lower, greater);
    }

private:

    Node* mRoot = null;
};

Node* merge(Node* lower, Node* greater)
{
    if(!lower)
        return greater;

    if(!greater)
        return lower;

    if(lower.y < greater.y)
    {
        lower.right = merge(lower.right, greater);
        return lower;
    }
    else
    {
        greater.left = merge(lower, greater.left);
        return greater;
    }
}

Node* merge(Node* lower, Node* equal, Node* greater)
{
    return merge(merge(lower, equal), greater);
}

void split(Node* orig, ref Node* lower, ref Node* greaterOrEqual, int val)
{
    if(!orig)
    {
        lower = null;
        greaterOrEqual = null;
        return;
    }

    if(orig.x < val)
    {
        lower = orig;
        split(lower.right, lower.right, greaterOrEqual, val);
    }
    else
    {
        greaterOrEqual = orig;
        split(greaterOrEqual.left, lower, greaterOrEqual.left, val);
    }
}

void split(Node* orig, ref Node* lower, ref Node* equal, ref Node* greater, int val)
{
    Node* equalOrGreater;
    split(orig, lower, equalOrGreater, val);
    split(equalOrGreater, equal, greater, val + 1);
}

int main(string[] args)
{
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
    writeln(res);
    return 0;
}
