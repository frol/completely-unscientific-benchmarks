defmodule BulkOps do
  defmodule SplitResult do
    defstruct lower: nil, equal: nil, greater: nil
  end

  def merge(nil, greater), do: greater
  def merge(lower, nil), do: lower

  def merge(lower, greater) do
    if lower.y < greater.y do
      %{lower | right: merge(lower.right, greater)}
    else
      %{greater | left: merge(lower, greater.left)}
    end
  end

  def split_binary(nil, _value), do: {nil, nil}

  def split_binary(orig, value) do
    if orig.x < value do
      {first, second} = split_binary(orig.right, value)
      {%{orig | right: first}, second}
    else
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
