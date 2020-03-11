#lang racket

(struct node (x y left right) #:mutable)

;; Deliberatly using PRNG below while still non-deterministic here?
(define (make-random-node x)
  ; Use maximal value allowed in random for integers. 
  (node x (random 4294967087) #f #f))

(define (merge2 lower greater)
  (cond
    [(not lower)
     greater]
    [(not greater)
     lower]
    [(< (node-y lower) (node-y greater))
     (set-node-right! lower (merge2 (node-right lower) greater))
     lower]
    [else
     (set-node-left! greater (merge2 lower (node-left greater)))
     greater]))

(define (split2 orig val)
  (cond
    [(not orig)
     (values #f #f)]
    [(< (node-x orig) val)
     (define-values (first second) (split2 (node-right orig) val))
     (set-node-right! orig first)
     (values orig second)]
    [else
     (define-values (first second) (split2 (node-left orig) val))
     (set-node-left! orig second)
     (values first orig)]))

(define (merge3 lower equal greater)
  (merge2 (merge2 lower equal) greater))

(define (split3 orig val)
  (define-values (lower equal+greater) (split2 orig val))
  (define-values (equal greater) (split2 equal+greater (add1 val)))
  (values lower equal greater))

(define (has-value root x)
  (define-values (lower equal greater) (split3 root x))
  (define new-root (merge3 lower equal greater))
  ;; Why splitting to merge right afterwards?
  (values new-root equal))

(define (insert root x)
  (define-values (lower equal greater) (split3 root x))
  (merge3 lower
          (or equal (make-random-node x))
          greater))

(define (erase root x)
  (define-values (lower equal greater) (split3 root x))
  (merge2 lower greater))

(define (main n)
  (let loop ([root #f] [i 1] [cur 5] [res 0])
    (if (not (< i n))
        res
        (let ([cur (remainder (+ 43 (* 57 cur)) 10007)])
          (case (remainder i 3)
            [(0) (loop (insert root cur) (add1 i) cur res)]
            [(1) (loop (erase root cur) (add1 i) cur res)]
            [(2) (define-values (nroot equal) (has-value root cur))
                 (loop nroot (add1 i) cur (if equal (add1 res) res))])))))

(println (main 1000000))


