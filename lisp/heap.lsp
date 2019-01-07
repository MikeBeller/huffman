
(define HEAPSIZE 8)

(define (make-heap-from-vector v . args)
    (let ((lefunc (if (null? args) <= (car args))))
      (vector v 0 lefunc)))

(define (heapify v . args)
  (let ((h (apply 'make-heap-from-vector (cons v args))))
    (do-heapify h)))

(define (make-heap . args)
  (apply make-heap-from-vector (cons (vector.alloc HEAPSIZE) args)))

(define (heap:vec h) (aref h 0))
(define (heap:len h) (aref h 1))
(define (heap:func h) (aref h 2))

