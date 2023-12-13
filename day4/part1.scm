#!/usr/bin/csi -s

;(include "input-test.scm")
(include "input.scm")

(define (score winning player)
  (define (iter cards acc)
    (cond ((null? cards) acc)
          ((member (car cards) winning)
            (iter (cdr cards) (if (= acc 0) 1 (* acc 2))))
          (else
            (iter (cdr cards) acc))))
  (iter player 0))

(print
  (foldr + 0
    (map
      (lambda (card)
        (let ((winning (car card))
              (player  (cadr card)))
          (score winning player)))
      cards)))
