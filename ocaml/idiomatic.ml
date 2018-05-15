type node = {
  x : int;
  y : int;
  left : node option;
  right : node option;
}

let rec merge lower greater =
  match lower, greater with
  | None, None -> None
  | (Some _ as node), None | None, (Some _ as node) -> node
  | Some lower, Some {y} when lower.y < y ->
    Some {lower with right = merge lower.right greater}
  | Some _, Some greater ->
    Some {greater with left = merge lower greater.left}

let empty = None

let singleton value = {
  x = value;
  y = Random.int 0x3fffffff;
  left = None;
  right = None
}

let rec has_value tree value =
  match tree with
  | None -> false
  | Some {x; left; right} ->
    if x = value then true
    else if x < value then has_value right value
    else has_value left value

let insert tree value =
  let rec aux tree value =
    match tree with
    | None -> singleton value
    | Some ({x; y; left; right} as node) ->
      if x = value then node
      else if x < value then
        let right = aux right value in
        if right.y < y then
          {right with left = Some {node with right = right.left}}
        else
          {node with right = Some right}
      else
        let left = aux left value in
        if left.y < y then
          {left with right = Some {node with left = left.right}}
        else
          {node with left = Some left} in
  Some (aux tree value)

let rec erase tree value =
  match tree with
  | None -> None
  | Some ({x; left; right} as node) ->
    if x = value then merge left right
    else if x < value then Some {node with right = erase right value}
    else Some {node with left = erase left value}

let () =
  let rec loop tree cur res i =
    if i < 1000000 then
      let cur = (cur * 57 + 43) mod 10007 in
      match i mod 3 with
      | 0 -> loop (insert tree cur) cur res (i + 1)
      | 1 -> loop (erase tree cur) cur res (i + 1)
      | _ ->
        let res = if has_value tree cur then res + 1 else res in
        loop tree cur res (i + 1)
    else res in
  Printf.printf "%d\n" (loop empty 5 0 1)
