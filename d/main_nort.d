import core.stdc.stdlib;

//In lieu of runtime new, use malloc + placement new
T* make(T, Args...)(Args args)
{
    auto result = cast(T*) calloc(1,T.sizeof);
    result.__ctor(args);
    return result;
}

//In lieu of runtime destroy, use manual __dtor call + free
void destroy(T)(T* obj)
{
    if(!obj) return;
    obj.__dtor();
    obj.free();
}

version(LDC) extern(C)
{
    __gshared int _d_eh_personality(int, int, ulong, void*, void*) { return 0;};
    __gshared void _d_eh_resume_unwind(void*) { return ;};
}

align((void*).sizeof):
private struct Node
{

    int x = 0;
    int y = 0;

    this(int x)
    {
        this.x = x;
        y = rand();
    }

    ~this()
    {
        left.destroy();
        right.destroy();
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
        merge(lower, equal, greater, mRoot);
        return res;
    }

    void insert(int x)
    {
        Node* lower, equal, greater;
        split(mRoot, lower, equal, greater, x);
        if(!equal)
            equal = make!Node(x);

        merge(lower, equal, greater, mRoot);
    }

    void erase(int x)
    {
        Node* lower, equal, greater;
        split(mRoot, lower, equal, greater, x);
        merge(lower, greater, mRoot);

        //Equivalent of delete in C++
        if(equal) equal.destroy();
    }

    ~this()
    {
        mRoot.destroy();
    }

    private Node* mRoot = null;
};

void merge()(Node* lower, Node* greater, ref Node* dest)
{
    if(!lower)
    {
        dest = greater;
        return;
    }

    if(!greater)
    {
        dest = lower;
        return;
    }

    if(lower.y < greater.y)
    {
        dest = lower;
        merge(lower.right, greater, lower.right);
    }
    else
    {
        dest = greater;
        merge(lower, greater.left, greater.left);
    }
}

void merge()(Node* lower, Node* equal, Node* greater, ref Node* res)
{
    merge(lower, equal, res);
    merge(res, greater, res);
}

void split()(Node* orig, ref Node* lower, ref Node* greaterOrEqual, int val)
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

void split()(Node* orig, ref Node* lower, ref Node* equal, ref Node* greater, int val)
{
    Node* equalOrGreater;
    split(orig, lower, equalOrGreater, val);
    split(equalOrGreater, equal, greater, val + 1);
}

extern(C)
int main(string[] args)
{
    import core.stdc.stdio;
    import core.stdc.time;

    srand(cast(uint)time(null));
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
    printf("%d\n", res);
    return 0;
}
