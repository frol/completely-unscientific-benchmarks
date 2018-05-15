(ns bench.core
  (:gen-class))

;; Exponentiation:
(defn ** [x n] (reduce * (repeat n x)))

;; Why using PRNG below why still non-deterministic here?
(defn make-random-node [x]
  {:x x
   :y (rand-int (** 2 31))
   :left nil
   :right nil})

(defn merge2 [lower greater]
  (if-not lower
    greater
    (if-not greater
      lower
      (if (< (:y lower) (:y greater))
        (assoc lower :right (merge2 (:right lower) greater))
        (assoc greater :left (merge2 lower (:left greater)))))))

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
      (let [cur (mod (+ 43 (* 57 cur)) 10007)]
        (case (mod i 3)
          0 (recur (insert root cur) (inc i) cur res)
          1 (recur (erase root cur) (inc i) cur res)
          2 (let [[root equal] (has-value root cur)
                  new-res (if equal (inc res) res)]
              (recur root (inc i) cur new-res)))))))

(defn -main [& args]
  (println (main 1000000)))


