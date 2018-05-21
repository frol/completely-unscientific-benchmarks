import std.stdio, std.random;

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

    static Node merge(Node lower, Node greater)
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

    static NodePair splitBinary(Node orig, int value)
    {
        if (orig is null)
            return NodePair(null, null);

        if (orig.x < value)
        {
            NodePair splitPair = splitBinary(orig.right, value);
            orig.right = splitPair.first;
            return NodePair(orig, splitPair.second);
        }
        else
        {
            NodePair splitPair = splitBinary(orig.left, value);
            orig.left = splitPair.second;
            return NodePair(splitPair.first, orig);
        }
    }

    static Node merge(Node lower, Node equal, Node greater)
    {
        return merge(merge(lower, equal), greater);
    }

    static SplitResult split(Node orig, int value)
    {
        NodePair lowerOther = splitBinary(orig, value);
        NodePair equalGreater = splitBinary(lowerOther.second, value + 1);
        return SplitResult(lowerOther.first, equalGreater.first, equalGreater.second);
    }
}

class Tree
{
    private Node mRoot = null;

    bool hasValue(int x)
    {
        SplitResult splited = Node.split(mRoot, x);
        bool res = splited.equal !is null;
        mRoot = Node.merge(splited.lower, splited.equal, splited.greater);
        return res;
    }

    void insert(int x)
    {
        SplitResult splited = Node.split(mRoot, x);
        if (splited.equal is null)
            splited.equal = new Node(x);
        mRoot = Node.merge(splited.lower, splited.equal, splited.greater);
    }

    void erase(int x)
    {
        SplitResult splited = Node.split(mRoot, x);
        mRoot = Node.merge(splited.lower, splited.greater);
    }
}

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