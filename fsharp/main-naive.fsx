#!/usr/bin/fsharpi
// #!/usr/bin/dotnet /usr/share/dotnet/sdk/2.1.300-rc1-008673/FSharp/fsi.exe
//
// Mono 4.2.1 is dog slow on this benchmark. You may try .Net Core
// with with the commented shebang line instead.
//
// See also Ocaml version in ../ocaml/immutable.ml
//
type Node = {
  x: int
  y: int
  left: option<Node>
  right: option<Node>
}

let rand_int = (let rng = System.Random() in fun () -> rng.Next())

let make_node (x: int) =
  Some {x = x; y = rand_int (); left = None; right = None}

let rec merge2 lower greater =
  match lower, greater with
  | None, greater -> greater
  | lower, None -> lower
  | Some lo, Some gt ->
      if lo.y < gt.y
      then Some {lo with right = merge2 lo.right greater}
      else Some {gt with left = merge2 lower gt.left}

let rec split2 orig value =
  match orig with
  | None -> (None, None)
  | Some orig ->
      if orig.x < value then
        let fst, snd = split2 orig.right value
        in (Some {orig with right = fst}, snd)
      else
        let fst, snd = split2 orig.left value
        in (fst, Some {orig with left = snd})

let merge3 lower equal greater =
  merge2 (merge2 lower equal) greater

let split3 orig value =
  let lower, equal_greater = split2 orig value in
  let equal, greater = split2 equal_greater (value + 1) in
  (lower, equal, greater)

let has_value root x =
  let lower, equal, greater = split3 root x in
  // FIXME: splitting just to merge it again:
  ((merge3 lower equal greater), equal <> None)

let insert root x =
  let lower, equal, greater = split3 root x in
  let equal = (if equal <> None then equal else make_node x) in
  merge3 lower equal greater

let erase root x =
  let lower, _, greater = split3 root x in
  merge2 lower greater

// Hm, if you put the loop into a main you will get
// a stack overflow in mono & dotnet core:
let () =
  let rec loop root i cur res =
    if i >= 1000000
    then res
    else
      let cur = (cur * 57 + 43) % 10007 in
      match i % 3 with
      | 0 -> loop (insert root cur) (i + 1) cur res
      | 1 -> loop (erase root cur) (i + 1) cur res
      | _ ->
        let root, flag = has_value root cur in
        loop root (i + 1) cur (if flag then res + 1 else res)
  in printfn "%d" (loop None 1 5 0)
 