
type Node = 
  {x: int
   y: int
   left: option<Node>
   right: option<Node>}

let rand_int = (let rng = System.Random() in fun () -> rng.Next())

let make_node (x: int) =
  Some({x = x; y = rand_int (); left = None; right = None})

let rec merge2 lower greater =
  match (lower, greater) with
  | (None, greater) -> greater
  | (lower, None) -> lower
  | (Some(lo), Some(gt)) ->
      if lo.y < gt.y
      then Some({lo with right = merge2 lo.right greater})
      else Some({gt with left = merge2 lower gt.left})

let rec splitBinary orig value =
  match orig with
  | None -> (None, None)
  | Some(orig) ->
      if orig.x < value then
        let (fst, snd) = splitBinary orig.right value
        in (Some({orig with right = fst}), snd)
      else
        let (fst, snd) = splitBinary orig.left value
        in (fst, Some({orig with left = snd}))

let merge3 lower equal greater = merge2 (merge2 lower equal) greater

let split orig value =
  let (lower, equal_greater) = splitBinary orig value in
  let (equal, greater) = splitBinary equal_greater (value + 1) in
  (lower, equal, greater)

// printfn "%A" (split (merge2 (make_node 42) (make_node 43)) 43)

let has_value root x =
  let (lower, equal, greater) = split root x in
  // FIXME: splitting just to merge it again:
  ((merge3 lower equal greater), equal <> None)

let insert root x =
  let (lower, equal, greater) = split root x in
  (merge3 lower (if equal <> None then equal else make_node x) greater)

let erase root x =
  let (lower, _, greater) = split root x in
  merge2 lower greater

let main n =
  let rec loop root i cur res =
    if i >= n
    then res
    else
      let cur = (cur * 57 + 43) % 1007 in
        match i % 3 with
        | 0 -> loop (insert root cur) (i + 1) cur res
        | 1 -> loop (erase root cur) (i + 1) cur res
        | _ -> let (root, flag) = has_value root cur in
                  if flag then loop root (i + 1) cur res + 1
                  else loop root (i + 1) cur res
  in loop None 1 5 0
// FIXME: stack overflow in mono:
in printfn "%d" (main 1000000)
