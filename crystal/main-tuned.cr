record SplitResult, lower : Pointer(Node), equal : Pointer(Node), greater : Pointer(Node)

struct Node
  property x : Int32 = 0
  property y : Int32 = Random.rand(Int32::MAX)
  property left : Pointer(Node) = Pointer(Node).null
  property right : Pointer(Node) = Pointer(Node).null

  def initialize(@x)
  end
end

def merge(lower : Pointer(Node), greater : Pointer(Node)) : Pointer(Node)
  if lower.null?
    return greater
  elsif greater.null?
    return lower
  elsif lower.value.y < greater.value.y
    lower.value.right = merge(lower.value.right, greater)
    return lower
  else
    greater.value.left = merge(lower, greater.value.left)
    return greater
  end
end

def merge3(lower : Pointer(Node), equal : Pointer(Node), greater : Pointer(Node)) : Pointer(Node)
  return merge(merge(lower, equal), greater)
end

def split_binary(orig : Pointer(Node), value : Int32) : {Pointer(Node), Pointer(Node)}
  # p "split_binary"
  if (orig.null?)
    return {Pointer(Node).null, Pointer(Node).null}
  elsif orig.value.x < value
    split_pair = split_binary(orig.value.right, value)
    orig.value.right = split_pair[0]
    return {orig, split_pair[1]}
  else
    split_pair = split_binary(orig.value.left, value)
    orig.value.left = split_pair[1]
    return {split_pair[0], orig}
  end
end

def split(orig : Pointer(Node), value : Int32)
  lower, equal_greater = split_binary(orig, value)
  equal, greater = split_binary(equal_greater, value + 1)
  return SplitResult.new lower, equal, greater
end

class Tree
  @root : Pointer(Node) = Pointer(Node).null

  def has_value(x)
    splited = split(@root, x)
    res = !splited.equal.null?
    @root = merge3(splited.lower, splited.equal, splited.greater)
    return res
  end

  def insert(x)
    splited = split(@root, x)
    equal = splited.equal
    if equal.null?
      node = Node.new(x)
      equal = Pointer.malloc(1, node)
    end

    @root = merge3(splited.lower, equal, splited.greater)
  end

  def erase(x)
    splited = split(@root, x)
    @root = merge(splited.lower, splited.greater)
  end
end

def main
  tree = Tree.new
  cur = 5
  res = 0

  (1...1000000).each do |i|
    a = i % 3
    cur = (cur * 57 + 43) % 10007

    case a
    when 0
      # p "insert"
      tree.insert(cur)
    when 1
      # p "erase"
      tree.erase(cur)
    when 2
      # p "has_value"
      res += tree.has_value(cur) ? 1 : 0
    end
  end
  p res
end

main()
