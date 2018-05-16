type node = {
  x : int;
  y : int;
  left : node option;
  right : node option;
}

let rec merge2 lower greater =
  match lower, greater with
  | None, None -> None
  | (Some _ as node), None | None, (Some _ as node) -> node
  | Some lower, Some {y} when lower.y < y ->
    Some {lower with right = merge2 lower.right greater}
  | Some _, Some greater ->
    Some {greater with left = merge2 lower greater.left}

let rec split2 orig value =
  match orig with
  | None -> (None, None)
  | Some orig when orig.x < value ->
    let first, second = split2 orig.right value in
    (Some {orig with right = first}, second)
  | Some orig ->
    let first, second = split2 orig.left value in
    (first, Some {orig with left = second})

let rec merge3 lower equal greater =
  merge2 (merge2 lower equal) greater

let split3 orig value =
  let lower, equal_greater = split2 orig value in
  let equal, greater = split2 equal_greater (value + 1) in
  (lower, equal, greater)

let empty = None

let singleton value = Some {
    x = value;
    y = Random.int 0x3fffffff;
    left = None;
    right = None
  }

let has_value tree value =
  let lower, equal, greater = split3 tree value in
  (merge3 lower equal greater, equal <> None)

let insert tree value =
  let lower, equal, greater = split3 tree value in
  let equal = if equal = None then singleton value else equal in
  merge3 lower equal greater

let erase tree value =
  let lower, _, greater = split3 tree value in
  merge2 lower greater

let () =
  let rec loop tree cur res i =
    if i < 1000000 then
      let cur = (cur * 57 + 43) mod 10007 in
      match i mod 3 with
      | 0 -> loop (insert tree cur) cur res (i + 1)
      | 1 -> loop (erase tree cur) cur res (i + 1)
      | _ ->
        let tree, b = has_value tree cur in
        loop tree cur (if b then res + 1 else res) (i + 1)
    else res in
  Printf.printf "%d\n" (loop empty 5 0 1)
