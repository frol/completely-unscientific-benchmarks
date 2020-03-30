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
