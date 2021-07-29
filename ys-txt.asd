(asdf:defsystem ys-txt
  :version "0.0.1"
  :author "Kevin Anderson"
  :serial T
  :components ((:file "package")
               (:file "util")
               (:file "app"))
  :depends-on (:chirp
               :str
               :cl-fad
               :alexandria
               :local-time
               :named-readtables))
