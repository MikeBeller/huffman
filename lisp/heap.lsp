
(define HEAPSIZE 64)

(define (make-heap-from-vector v . args)
    (let ((lefunc (if (null? args) <= (car args))))
      (vector v 0 lefunc)))

(define (heapify v . args)
  (let ((h (apply make-heap-from-vector (cons v args))))
    (do-heapify h)
    h))

(define (make-heap . args)
  (apply make-heap-from-vector (cons (vector.alloc HEAPSIZE) args)))

(define (heap:vec h) (aref h 0))
(define (heap:len h) (aref h 1))
(define (heap:func h) (aref h 2))
(define (heap:get h i) (aref (heap:vec h) i))

(define (heap:parent n) (fixnum (/ (- n 1) 2)))
(assert (eq? (heap:parent 1) 0))
(assert (eq? (heap:parent 2) 0))
(assert (eq? (heap:parent 8) 3))
(define (heap:has-parent n) (> n 0))

(define (heap:left n) (+ 1 (* n 2)))
(define (heap:right n) (+ 2 (* n 2)))

(let ((h (make-heap)))
  (assert (equal? (heap:vec h) (vector.alloc HEAPSIZE)))
  (assert (eq? (heap:len h) 0))
  (assert (eq? (heap:func h) <=)))

(let ((h (make-heap >=)))
  (assert (equal? (heap:vec h) (vector.alloc HEAPSIZE)))
  (assert (eq? (heap:len h) 0))
  (assert (eq? (heap:func h) >=)))

(define (heap:right-child-exists h n)
  (< (heap:right n) (heap:len h)))

(define (heap:left-child-exists h n)
  (< (heap:left n) (heap:len h)))

(define (aswap! v i j)
  (let ((vi (aref v i))
        (vj (aref v j)))
    (aset! v j vi)
    (aset! v i vj)))

(define (heap:swap-if-needed h n k)
  (let ((v (heap:vec h))
        (lt (heap:func h)))
    (if (lt (aref v k) (aref v n))
      (aswap! v n k))))

(define (do-heapify h)
  (let ((v (heap:vec h))
        (l (heap:len h))
        (ltf (heap:func h)))
    (do ((n (heap:parent l) (- n 1))) ((< n 0))
      (heap:swap-if-needed h n (heap:left n))
      (if (heap:right-child-exists h n)
        (heap:swap-if-needed h n (heap:right n))))))

(define (heap:verify h i)
  (if (>= i (heap:len h)) #t)
  (if (heap:has-parent i)
    (if (not ((heap:func h) (heap:get h (heap:parent i)) (heap:val h i)))
      #f
      (and (heap:verify h (heap:left i))
           (heap:verify h (heap:right i))))))

