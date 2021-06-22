import scala.annotation.tailrec
import scala.util.Random

case class SplitResult(lower: Option[Node], equal: Option[Node], greater: Option[Node]) {
  def flatten: Seq[Node] = Seq(lower, equal, greater).flatten
  def sides: Seq[Node]   = Seq(lower, greater).flatten
}

class NodePair(val first: Option[Node], val second: Option[Node])

case class Node(
                 x: Int,
                 left: Option[Node] = None,
                 right: Option[Node] = None,
                 y: Int = Node.random.nextInt
               )

case class Tree(mRoot: Option[Node] = None) {
  def foldValue(x: Int, res: Int): (Int, Tree) = {
    mRoot.map(Node.split(_, x)).fold(res -> this) { r =>
      r.equal.fold(res)(_ => res + 1) -> copy(Some(Node.merge(r.flatten: _*)))
    }
  }

  def insert(x: Int): Tree = {
    mRoot.map(Node.split(_, x)).fold(copy(Some(Node(x)))) { r =>
      copy(Some(Node.merge(Seq(r.lower, Some(r.equal.getOrElse(Node(x, None, None))), r.greater).flatten: _*)))
    }
  }

  def erase(x: Int): Tree = {
    mRoot.map(Node.split(_, x)).fold(this) { r =>
      val side = r.sides
      if (side.isEmpty) {
        copy(None)
      } else copy(Some(Node.merge(side: _*)))
    }
  }
}

object Node {

  lazy final val random = new Random

  @tailrec
  def merge(entries: Node*): Node = {
    entries.toList match {
      case a :: b :: x =>
        merge(
          x.+:(if (a.y < b.y) {
            a.copy(right = Some(a.right.fold(b)(outlineMerge(_, b))), y = a.y)
          } else {
            b.copy(left = Some(b.left.fold(a)(outlineMerge(a, _))), y = b.y)
          }): _*
        )
      case e :: _ => e
    }
  }
  def outlineMerge(entries: Node*): Node = {
    merge(entries: _*)
  }

  def split(orig: Node, value: Int): SplitResult = {
    val f = splitBinary(orig, value)
    val s = f.second.map(splitBinary(_, value + 1))
    SplitResult(f.first, s.flatMap(_.first), s.flatMap(_.second))
  }

  private[this] def splitBinary(orig: Node, value: Int): NodePair = {
    if (orig.x < value) {
      val splitVal = orig.right.map(splitBinary(_, value))
      new NodePair(Some(orig.copy(right = splitVal.flatMap(_.first), y = orig.y)), splitVal.flatMap(_.second))
    } else {
      val splitVal = orig.left.map(splitBinary(_, value))
      new NodePair(splitVal.flatMap(_.first), Some(orig.copy(left = splitVal.flatMap(_.second), y = orig.y)))
    }
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
          val (nr, nt) = tree.foldValue(nextcur, res)
          run(nextcur, nr, nt, i + 1)
      }
    } else {
      res
    }
  }

  println(run(5, 0, Tree()))
}
