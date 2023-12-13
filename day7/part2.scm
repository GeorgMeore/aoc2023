#!/usr/bin/csi -s

;(include "input-test.scm")
(include "input.scm")

(define (cutoff n l)
  (if (or (= n 0) (null? l))
      (cons '() l)
      (let ((rest (cutoff (- n 1) (cdr l))))
        (cons (cons (car l) (car rest)) (cdr rest)))))

(define (merge l1 l2 gt?)
  (cond ((null? l1) l2)
        ((null? l2) l1)
        ((gt? (car l1) (car l2))
          (cons (car l2) (merge l1 (cdr l2) gt?)))
        (else
          (cons (car l1) (merge (cdr l1) l2 gt?)))))

(define (merge-by n l gt?)
  (if (null? l)
      '()
      (let* ((cut1   (cutoff n l))
             (first  (car cut1))
             (cut2   (cutoff n (cdr cut1)))
             (second (car cut2))
             (rest   (cdr cut2)))
        (append (merge first second gt?)
                (merge-by n rest gt?)))))

(define (sort l gt?)
  (let ((len (length l)))
    (define (iter n acc)
      (if (>= n len)
          acc
          (iter (* n 2) (merge-by n acc gt?))))
    (iter 1 l)))

(define (count-occurences x l)
  (cond ((null? l) 0)
        ((equal? x (car l))
          (+ 1 (count-occurences x (cdr l))))
        (else
          (count-occurences x (cdr l)))))

(define (occurs? x l)
  (and (not (null? l)
       (or (equal? (car l) x)
           (occurs? x (cdr l))))))

(define (count-cards hand)
  (define (iter items acc)
    (if (null? items)
        acc
        (let* ((first (car items))
               (rest (cdr items))
               (cnt (assoc first acc)))
          (if cnt
              (iter rest acc)
              (iter rest
                    (cons (cons first (count-occurences first items))
                          acc))))))
  (iter hand '()))

(define (index-of x l)
  (define (iter l i)
    (cond ((null? l) #f)
          ((equal? (car l) x) i)
          (else
            (iter (cdr l) (+ 1 i)))))
  (iter l 0))

(define (max l)
  (define (iter l m)
    (cond ((null? l) m)
          ((> (car l) m) (iter (cdr l) (car l)))
          (else (iter (cdr l) m))))
  (iter l (car l)))

(define (hand-order hand)
  (let ((five-of-a-kind  6)
        (four-of-a-kind  5)
        (full-house      4)
        (three-of-a-kind 3)
        (two-pairs       2)
        (one-pair        1)
        (hight-card      0))
    (let* ((card-counts (count-cards hand))
           (joker-count
             (let ((count (assoc 'J card-counts)))
               (if count (cdr count) 0)))
           (other-counts
             (map (lambda (c)
                    (if (equal? (car c) 'J) 0 (cdr c)))
                  card-counts))
           (max-count (max other-counts))
           (pairs-count (count-occurences 2 other-counts))
           (signles-count (count-occurences 1 other-counts)))
      (cond ((= (+ max-count joker-count) 5)
              five-of-a-kind)
            ((= (+ max-count joker-count) 4)
              four-of-a-kind)
            ((or (and (= max-count 3) (= pairs-count 1))
                 (and (= joker-count 1) (= pairs-count 2)))
              full-house)
            ((= (+ max-count joker-count) 3)
              three-of-a-kind)
            ((= pairs-count 2)
              two-pairs)
            ((= (+ max-count joker-count) 2)
              one-pair)
            (else hight-card)))))

(define (hand-stronger? h1 h2)
  (let ((cards-order '(A K Q T 9 8 7 6 5 4 3 2 J)))
    (define (iter h1 h2)
      (and (not (null? h1))
          (let ((i1 (index-of (car h1) cards-order))
                (i2 (index-of (car h2) cards-order)))
            (or (< i1 i2)
                (and (= i1 i2) (iter (cdr h1) (cdr h2)))))))
    (iter h1 h2)))

(define (hand-greater? h1 h2)
  (let ((o1 (hand-order h1))
        (o2 (hand-order h2)))
    (or (> o1 o2)
        (and (= o1 o2)
             (hand-stronger? h1 h2)))))

(define (total-gain hands)
  (define (iter sorted i acc)
    (if (null? sorted)
        acc
        (iter (cdr sorted)
              (+ i 1)
              (+ acc (* i (cdar sorted))))))
  (iter (sort hands
              (lambda (x y)
                (hand-greater? (car x) (car y))))
        1
        0))

(print (total-gain hands))
