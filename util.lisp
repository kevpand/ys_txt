(in-package #:ys-txt)

(defun env-var (stream char)
  (declare (ignore char))
  `(sb-ext:posix-getenv
    (symbol-name
     (quote ,(read stream t nil t)))))

(defreadtable ys-txt-readtable
  (:merge :standard)
  (:macro-char #\$ #'env-var))

