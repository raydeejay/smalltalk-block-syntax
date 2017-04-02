;; Copyright 2016 Sergi Reyner
;; MIT License

(in-package #:smalltalk-block-syntax)

(defvar *previous-readtables* nil)

(defmacro enable-block-syntax ()
  "Enables Smalltalk-like syntax for defining lambda functions.

    [lambda-list || local1 local2 ... || (form1) (form2) ...]

expands into

    (LAMBDA lambda-list
      (LET (local1 local2)
        (form1)
        (form2)))

The empty symbol || is happily abused to take the place of
Smalltalk's | separator.
"
  '(eval-when (:compile-toplevel :load-toplevel :execute)
    (push *readtable* *previous-readtables*)
    (setf *readtable* (copy-readtable))
    (set-macro-character #\[
     (lambda (stream char)
       (declare (ignore char))
       (let ((*readtable* (copy-readtable)))
         (set-macro-character #\] (get-macro-character #\)))
         (let ((sexp (read-delimited-list #\] stream t)))
           (destructuring-bind (body &optional locals arguments)
               (reverse (split-sequence '|| sexp))
             (when (null arguments)
               (rotatef locals arguments))
             `(lambda ,arguments
                (let ,locals
                  ,@body)))))))))

(defmacro disable-block-syntax ()
  "Disables the extended syntax for Smalltalk blocks."
  '(eval-when (:compile-toplevel :load-toplevel :execute)
    (when *previous-readtables*
      (setf *readtable* (pop *previous-readtables*)))))
