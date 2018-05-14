;;
;; Execute with "clj main.clj"
;;

;; Exponentiation:
(defn ** [x n] (reduce * (repeat n x)))

;; Why using PRNG below why still non-deterministic here?
(defn make-random-node [x]
  {:x x
   :y (rand-int (** 2 31))
   :left nil
   :right nil})

(defn merge2 [lower greater]
  (if (nil? lower)
    greater
    (if (nil? greater)
      lower
      (if (< (:y lower) (:y greater))
        (assoc lower :right (merge2 (:right lower) greater))
        (assoc greater :left (merge2 lower (:left greater)))))))

(defn split-binary [orig value]
  (if (nil? orig)
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
    [new-root (nil? equal)]))

(defn insert [root x]
  (let [[lower equal greater] (split root x)]
    (merge3 lower
            (if (nil? equal)
              (make-random-node x)
              equal)
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
                         2 (let [[root flag] (has-value root cur)]
                             (if flag
                               [root (inc res)]
                               [root res])))]
        (recur root
               (inc i)
               cur
               res)))))

(println (main 1000000))
