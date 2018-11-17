import std.stdio, std.random;

/*
 *
 *  Data Structures
 *
 */

struct SplitResult
{
    Node lower, equal, greater;
}

struct NodePair
{
    Node first, second;
}

class Node
{
  private:
    int x, y;
    Node left = null;
    Node right = null;

  public:
    this(int x)
    {
        this.x = x;
        this.y = uniform!int();
    }
}

class Tree
{
    private Node mRoot = null;

    bool hasValue(int x)
    {
        SplitResult splitted = split(this.mRoot, x);
        bool res = splitted.equal !is null;
        this.mRoot = merge(splitted.lower, splitted.equal, splitted.greater);
        return res;
    }

    void insert(int x)
    {
        SplitResult splitted = split(this.mRoot, x);
        if (splitted.equal is null)
            splitted.equal = new Node(x);
        this.mRoot = merge(splitted.lower, splitted.equal, splitted.greater);
    }

    void erase(int x)
    {
        SplitResult splitted = split(this.mRoot, x);
        this.mRoot = merge(splitted.lower, splitted.greater);
    }
}


/*
 *
 *  Functions
 *
 */

Node merge(Node lower, Node greater)
{
    if (lower is null)
        return greater;

    if (greater is null)
        return lower;

    if (lower.y < greater.y)
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

NodePair splitBinary(Node original, int value)
{
    if (original is null)
        return NodePair(null, null);

    if (original.x < value)
    {
        NodePair splitPair = splitBinary(original.right, value);
        original.right = splitPair.first;
        return NodePair(original, splitPair.second);
    }
    else
    {
        NodePair splitPair = splitBinary(original.left, value);
        original.left = splitPair.second;
        return NodePair(splitPair.first, original);
    }
}

Node merge(Node lower, Node equal, Node greater)
{
    return merge(merge(lower, equal), greater);
}

SplitResult split(Node original, int value)
{
    NodePair lowerOther = splitBinary(original, value);
    NodePair equalGreater = splitBinary(lowerOther.second, value + 1);
    return SplitResult(lowerOther.first, equalGreater.first, equalGreater.second);
}


/*
 *
 *  Main
 *
 */

void main()
{
    Tree tree = new Tree();
    int cur = 5;
    int res = 0;

    foreach (int i; 1..1000000)
    {
        int a = i % 3;
        cur = (cur * 57 + 43) % 10007;

        if (a == 0)
        {
            tree.insert(cur);
        }
        else if (a == 1)
        {
            tree.erase(cur);
        }
        else if (a == 2)
        {
            bool hasVal = tree.hasValue(cur);
            if (hasVal)
                res++;
        }
    }

    res.writeln;
}