
type Node = 
  {x: int
   y: int
   left: option<Node>
   right: option<Node>}

let rand_int = (let rng = System.Random() in fun () -> rng.Next())

let make_node (x: int) =
  Some({x = x; y = rand_int (); left = None; right = None})

// printfn "%A" (make_node 42)

let rec merge2 lower greater =
  match (lower, greater) with
  | (None, greater) -> greater
  | (lower, None) -> lower
  | (Some(lo), Some(gt)) ->
      if lo.y < gt.y
      then Some({lo with right = merge2 lo.right greater})
      else Some({gt with left = merge2 lower gt.left})

printfn "%A" (merge2 (make_node 42) (make_node 43))

(*
(defn split-binary [orig value]
  (if-not orig
    [nil nil]
    (if (< (:x orig) value)
      (let [[fst snd] (split-binary (:right orig) value)]
        [(assoc orig :right fst) snd])
      (let [[fst snd] (split-binary (:left orig) value)]
        [fst (assoc orig :left snd)]))))

(defn merge3 [lower equal greater]
  (merge2 (merge2 lower equal) greater))

(defn split [orig value]
  (let [[lower equal-greater] (split-binary orig value)
        [equal greater] (split-binary equal-greater (inc value))]
    [lower equal greater]))

;; Very questionable function ...
(defn has-value [root x]
  (let [[lower equal greater] (split root x)
        new-root (merge3 lower equal greater)]
    ;; Why splitting to merge right afterwards? This seems to
    ;; be empirically true:
    ;; (assert (= root new-root))
    [new-root equal]))

(defn insert [root x]
  (let [[lower equal greater] (split root x)]
    (merge3 lower
            (or equal (make-random-node x))
            greater)))

(defn erase [root x]
  (let [[lower equal greater] (split root x)]
    (merge2 lower greater)))

(defn main [n]
  (loop [root nil
         i 1
         cur 5
         res 0]
    (if-not (< i n)
      res
      (let [a (mod i 3)
            cur (mod (+ 43 (* 57 cur)) 10007)
            ;; This simulates an in-place update in place and a side
            ;; result:
            [root res] (case a
                         0 [(insert root cur) res]
                         1 [(erase root cur) res]
                         2 (let [[root equal] (has-value root cur)]
                             (if equal
                               [root (inc res)]
                               [root res])))]
        (recur root
               (inc i)
               cur
               res)))))

(defn -main [& args]
  (println (main 1000000)))


*)