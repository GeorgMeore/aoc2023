#!/usr/bin/csi -s

;(include "input-test2.scm")
(include "input2.scm")

(define (distance hold-time race-time)
  (* (- race-time hold-time) hold-time))

(define (div2 x)
 (quotient x 2))

(define (bisect left right satisfies?)
  (let ((middle (+ left (div2 (- right left)))))
    (cond ((= left right) left)
          ((satisfies? middle)
            (bisect left middle satisfies?))
          (else
            (bisect (+ middle 1) right satisfies?)))))

(define (left-border race-time max-distance)
  (bisect 0
          (div2 race-time)
          (lambda (time)
            (> (distance time race-time) max-distance))))

(define (right-border race-time max-distance)
  (- (bisect (div2 race-time)
             (+ race-time 1)
             (lambda (time)
               (<= (distance time race-time) max-distance)))
     1))

(define (ways-to-win race)
  (let ((race-time (car race))
        (max-distance (cdr race)))
    (- (right-border race-time max-distance)
       (left-border race-time max-distance)
       -1)))

(print (ways-to-win race))
