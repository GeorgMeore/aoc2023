#!/usr/bin/csi -s

;(include "input-test1.scm")
(include "input1.scm")

(define (distance hold-time race-time)
  (* (- race-time hold-time) hold-time))

(define (ways-to-win race)
  (let ((race-time (car race))
        (max-distance (cdr race)))
    (define (iter hold-time acc)
      (cond ((= hold-time race-time) acc)
            ((> (distance hold-time race-time) max-distance)
              (iter (+ hold-time 1) (+ acc 1)))
            (else
              (iter (+ hold-time 1) acc))))
    (iter 1 0)))

(print (foldr * 1 (map ways-to-win races)))
