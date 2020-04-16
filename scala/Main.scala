import scala.annotation.tailrec
import scala.util.Random


class SplitResult(var lower: Node, var equal: Node, var greater: Node) {
}

class NodePair(val first: Node, val second: Node)

object Node {

  var random = new Random

  def merge(lower: Node, greater: Node): Node = {
    if (lower == null) return greater
    if (greater == null) return lower
    if (lower.y < greater.y) {
      lower.right = merge(lower.right, greater)
      lower
    }
    else {
      greater.left = merge(lower, greater.left)
      greater
    }
  }

  def splitBinary(orig: Node, value: Int): NodePair = {
    if (orig == null) return new NodePair(null, null)
    if (orig.x < value) {
      val splitPair = splitBinary(orig.right, value)
      orig.right = splitPair.first
      new NodePair(orig, splitPair.second)
    }
    else {
      val splitPair = splitBinary(orig.left, value)
      orig.left = splitPair.second
      new NodePair(splitPair.first, orig)
    }
  }

  def merge(lower: Node, equal: Node, greater: Node): Node = merge(merge(lower, equal), greater)

  def split(orig: Node, value: Int): SplitResult = {
    val lowerOther = splitBinary(orig, value)
    val equalGreater = splitBinary(lowerOther.second, value + 1)
    new SplitResult(lowerOther.first, equalGreater.first, equalGreater.second)
  }
}

case class Node(var x: Int, var left: Node = null, var right: Node = null) {
  val y: Int = Node.random.nextInt
}

class Tree(var mRoot: Node = null) {
  def hasValue(x: Int, res: Int): (Int, Tree) = {
    val splited = Node.split(mRoot, x)
    (if (splited.equal != null) res + 1 else res) -> {
      mRoot = Node.merge(splited.lower, splited.equal, splited.greater)
      this
    }
  }

  def insert(x: Int): Tree = {
    val splited = Node.split(mRoot, x)
    if (splited.equal == null) {
      splited.equal = new Node(x)
    }
    mRoot = Node.merge(splited.lower, splited.equal, splited.greater)
    this
  }

  def erase(x: Int): Tree = {
    val splited = Node.split(mRoot, x)
    mRoot = Node.merge(splited.lower, splited.greater)
    this
  }
}

object Main extends App {

  @tailrec
  def run(cur: Int, res: Int, tree: Tree, i: Int = 1): Int = {
    if (i < 1000000) {
      val nextcur = (cur * 57 + 43) % 10007
      i % 3 match {
        case 0 => run(nextcur, res, tree.insert(nextcur), i + 1)
        case 1 => run(nextcur, res, tree.erase(nextcur), i + 1)
        case 2 =>
          val (nr, nt) = tree.hasValue(nextcur, res)
          run(nextcur, nr, nt, i + 1)
      }
    } else {
      res
    }
  }

  println(run(5, 0, new Tree()))
}