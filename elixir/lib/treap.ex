defmodule Treap do
  defmodule TreapNode do
    defstruct x: nil, y: nil, left: nil, right: nil
  end

  def has_value?(root, x) do
    splitted = BulkOps.split(root, x)
    res = splitted.equal != nil
    root = BulkOps.merge3(splitted.lower, splitted.equal, splitted.greater)
    {root, res}
  end

  def insert(root, x) do
    splitted = BulkOps.split(root, x)

    if splitted.equal == nil do
      BulkOps.merge3(splitted.lower, %TreapNode{x: x, y: :rand.uniform()}, splitted.greater)
    else
      BulkOps.merge3(splitted.lower, splitted.equal, splitted.greater)
    end
  end

  def erase(root, x) do
    splitted = BulkOps.split(root, x)
    BulkOps.merge(splitted.lower, splitted.greater)
  end
end
