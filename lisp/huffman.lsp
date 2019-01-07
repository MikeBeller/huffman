; Huffman coding in femtolisp

(define (make-node val tag left right)
  [val tag left right])
(define (node:val n) (aref n 0))
(define (node:tag n) (aref n 1))
(define (node:left n) (aref n 2))
(define (node:right n) (aref n 3))

(define (node-le a b) (<= (node-val a) (node-val b)))


