type node = {
  x : int;
  y : int;
  mutable left : node option;
  mutable right : node option;
}

type tree = node ref

let rec merge2 lower greater =
  match lower, greater with
  | None, None -> None
  | (Some _ as node), None | None, (Some _ as node) -> node
  | Some l, Some g when l.y < g.y ->
    l.right <- merge2 l.right greater;
    lower
  | Some l, Some g ->
    g.left <- merge2 lower g.left;
    greater

let rec split2 orig value =
  match orig with
  | None -> (None, None)
  | Some o when o.x < value ->
    let first, second = split2 o.right value in
    o.right <- first;
    (orig, second)
  | Some o ->
    let first, second = split2 o.left value in
    o.left <- second;
    (first, orig)

let rec merge3 lower equal greater =
  merge2 (merge2 lower equal) greater

let split3 orig value =
  let lower, equal_greater = split2 orig value in
  let equal, greater = split2 equal_greater (value + 1) in
  (lower, equal, greater)

let make_tree () = ref None

let singleton value = Some {
  x = value;
  y = Random.int 0x3fffffff;
  left = None;
  right = None
}

let has_value tree value =
  let lower, equal, greater = split3 !tree value in
  tree := merge3 lower equal greater;
  equal <> None

let insert tree value =
  let lower, equal, greater = split3 !tree value in
  let equal = if equal = None then singleton value else equal in
  tree := merge3 lower equal greater

let erase tree value =
  let lower, _, greater = split3 !tree value in
  tree := merge2 lower greater

let () =
  let tree = make_tree () in
  let rec loop cur res i =
    if i < 1000000 then
      let cur = (cur * 57 + 43) mod 10007 in
      match i mod 3 with
      | 0 ->
        insert tree cur;
        loop cur res (i + 1)
      | 1 ->
        erase tree cur;
        loop cur res (i + 1)
      | _ ->
        let res = if has_value tree cur then res + 1 else res in
        loop cur res (i + 1)
    else res in
  Printf.printf "%d\n" (loop 5 0 1)
