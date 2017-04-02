;;;; smalltalk-block-syntax.asd

(asdf:defsystem #:smalltalk-block-syntax
  :description "Emulating Smalltalk blocks"
  :author "Sergi Reyner <sergi.reyner@gmail.com>"
  :license "MIT"
  :depends-on (:split-sequence)
  :serial t
  :components ((:file "package")
               (:file "smalltalk-block-syntax")))

