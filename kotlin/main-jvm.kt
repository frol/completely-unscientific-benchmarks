import kotlin.io.*
import java.util.Random

val random = Random()

class Node(var x: Int)
{    
    var y = random.nextInt()
    var left: Node? = null
    var right: Node? = null
}

fun merge(lower: Node?, greater: Node?): Node?
{
    if(lower == null)
    	return greater
    
    if(greater == null)
    	return lower
    
    if(lower.y < greater.y)
    {
        lower.right = merge(lower.right, greater)
        return lower
    }
    else
    {
        greater.left = merge(lower, greater.left)
        return greater
    }
}

fun splitBinary(orig: Node?, value: Int): Pair<Node?, Node?>
{
    if(orig == null)
    	return Pair(null, null)
    
    if(orig.x < value)
    {
        val splitPair = splitBinary(orig.right, value)
        orig.right = splitPair.first
        return Pair(orig, splitPair.second)
    }
    else
    {
        val splitPair = splitBinary(orig.left, value)
        orig.left = splitPair.second
        return Pair(splitPair.first, orig)
    }
}

fun merge(lower: Node?, equal: Node?, greater: Node?): Node?
{
    return merge(merge(lower, equal), greater)
}

class SplitResult(val lower: Node?, var equal: Node?, var greater: Node?)

fun split(orig: Node?, value: Int): SplitResult
{
    val (lower, equalGreater) = splitBinary(orig, value)
    val (equal, greater) = splitBinary(equalGreater, value + 1)
    return SplitResult(lower, equal, greater)
}

class Tree
{
    public fun hasValue(x: Int): Boolean
    {
        val splited = split(mRoot, x)
        val res = splited.equal != null
        mRoot = merge(splited.lower, splited.equal, splited.greater)
        return res
    }
    
    public fun insert(x: Int)
    {
        val splited = split(mRoot, x)
        if(splited.equal == null)
        	splited.equal = Node(x)
        mRoot = merge(splited.lower, splited.equal, splited.greater)
    }
    
    public fun erase(x: Int)
    {
        val splited = split(mRoot, x)
        mRoot = merge(splited.lower, splited.greater)
    }
    
    private var mRoot: Node? = null
}

fun main(args: Array<String>) 
{
    val tree = Tree()
    var cur = 5;
    var res = 0

    for(i in 1..1000000)
    {
        val a = i % 3
        cur = (cur * 57 + 43) % 10007
        when(a)
        {
            0 -> tree.insert(cur)
            1 -> tree.erase(cur)
            2 -> res += if(tree.hasValue(cur)) 1 else 0
        }
    }
    println(res)
}
