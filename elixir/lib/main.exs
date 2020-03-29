defmodule TreapNode do
  defstruct x: nil, y: :rand.uniform(), left: nil, right: nil
end

defmodule BulkOps do
  defmodule SplitResult do
    defstruct lower: nil, equal: nil, greater: nil
  end

  def merge(lower, greater) do
    cond do
      lower == nil ->
        greater

      greater == nil ->
        lower

      lower.y < greater.y ->
        %{lower | right: merge(lower.right, greater)}

      true ->
        %{greater | left: merge(lower, greater.left)}
    end
  end

  def split_binary(orig, value) do
    cond do
      orig == nil ->
        {nil, nil}

      orig.x < value ->
        {first, second} = split_binary(orig.right, value)
        {%{orig | right: first}, second}

      true ->
        {first, second} = split_binary(orig.left, value)
        {first, %{orig | left: second}}
    end
  end

  def merge3(lower, equal, greater) do
    merge(merge(lower, equal), greater)
  end

  def split(orig, value) do
    {lower, equal_greater} = split_binary(orig, value)
    {equal, greater} = split_binary(equal_greater, value + 1)
    %SplitResult{lower: lower, equal: equal, greater: greater}
  end
end

defmodule Treap do
  def has_value?(root, x) do
    splitted = BulkOps.split(root, x)
    res = splitted.equal != nil
    root = BulkOps.merge3(splitted.lower, splitted.equal, splitted.greater)
    {root, res}
  end

  def insert(root, x) do
    splitted = BulkOps.split(root, x)

    if splitted.equal == nil do
      BulkOps.merge3(splitted.lower, %TreapNode{x: x}, splitted.greater)
    else
      BulkOps.merge3(splitted.lower, splitted.equal, splitted.greater)
    end
  end

  def erase(root, x) do
    splitted = BulkOps.split(root, x)
    BulkOps.merge(splitted.lower, splitted.greater)
  end
end

{_cur, _root, res} =
  Enum.reduce(1..1_000_000, {5, nil, 0}, fn i, acc ->
    {cur, root, res} = acc
    a = rem(i, 3)
    cur = rem(cur * 57 + 43, 10007)

    case a do
      0 ->
        root = Treap.insert(root, cur)
        {cur, root, res}

      1 ->
        root = Treap.erase(root, cur)
        {cur, root, res}

      2 ->
        {root, present} = Treap.has_value?(root, cur)
        res = if present, do: res + 1, else: res
        {cur, root, res}
    end
  end)

IO.puts(res)
