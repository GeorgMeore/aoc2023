#!/usr/bin/csi -s

;(include "input-test.scm")
(include "input.scm")

(define (card-score card)
  (let ((winning (car card))
        (player  (cadr card)))
    (define (iter cards acc)
      (cond ((null? cards) acc)
            ((member (car cards) winning)
              (iter (cdr cards) (+ acc 1)))
            (else
              (iter (cdr cards) acc))))
    (iter player 0)))

(define (bump-counts counts n diff)
  (if (or (null? counts) (= n 0))
      counts
      (cons (+ diff (car counts))
            (bump-counts (cdr counts) (- n 1) diff))))

(define (total-score cards)
  (define (iter cards counts acc)
    (if (null? cards)
        acc
        (let ((first-score (card-score (car cards)))
              (first-count (car counts)))
          (iter (cdr cards)
                (bump-counts (cdr counts) first-score first-count)
                (+ acc first-count)))))
  (iter cards (map (lambda (card) 1) cards) 0))

(print (total-score cards))
