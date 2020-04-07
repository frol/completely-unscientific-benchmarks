class Node
  property x : Int32
  property y : Int32
  property right : Node?
  property left : Node?

  def initialize(x)
    @x = x
    @y = Random.rand(Int32::MAX)
  end
end

def merge(lower, greater)
  if lower.nil?
    return greater
  elsif greater.nil?
    return lower
  elsif lower.y < greater.y
    lower.right = merge(lower.right, greater)
    return lower
  else
    greater.left = merge(lower, greater.left)
    return greater
  end
end

def split_binary(orig, value)
  if orig.nil?
    return {nil, nil}
  elsif orig.x < value
    split_pair = split_binary(orig.right, value)
    orig.right = split_pair[0]
    return {orig, split_pair[1]}
  else
    split_pair = split_binary(orig.left, value)
    orig.left = split_pair[1]
    return {split_pair[0], orig}
  end
end

def merge3(lower, equal, greater)
  return merge(merge(lower, equal), greater)
end

struct SplitResult
  property lower : Node?
  property equal : Node?
  property greater : Node?

  def initialize(@lower, @equal, @greater)
  end
end

def split(orig, value)
  lower, equal_greater = split_binary(orig, value)
  equal, greater = split_binary(equal_greater, value + 1)
  return SplitResult.new lower, equal, greater
end

struct Tree
  def initialize
    @root = nil
  end

  @root : Node?

  def has_value(x)
    splited = split(@root, x)
    res = splited.equal != nil
    @root = merge3(splited.lower, splited.equal, splited.greater)
    return res
  end

  def insert(x)
    splited = split(@root, x)
    splited.equal = Node.new(x) if splited.equal.nil?

    @root = merge3(splited.lower, splited.equal, splited.greater)
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
    when 0; tree.insert(cur)
    when 1; tree.erase(cur)
    when 2
      res += tree.has_value(cur) ? 1 : 0
    end
  end
  puts res
end

main()
