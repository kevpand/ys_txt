(in-package :ys-txt)
(in-readtable ys-txt-readtable)

(defparameter *hour* 11)
(defparameter *minute* 0)

(defun grab-lyrics ()
  (alexandria:shuffle
   (remove-if #'(lambda (str) (str:emptyp str))
              (alexandria:flatten
               (let ((files (cl-fad:list-directory "lyrics")))
                 (loop for file in files collect (str:lines (str:from-file file))))))))

(defun main ()
  (let ((chirp:*oauth-api-key* $YS_API_KEY)
        (chirp:*oauth-api-secret* $YS_API_SECRET)
        (chirp:*oauth-access-token* $YS_ACCESS_TOKEN)
        (chirp:*oauth-access-secret* $YS_ACCESS_SECRET)
        (local-time:*default-timezone* local-time:+utc-zone+))
    (ys-txt (grab-lyrics))))

(defun ys-txt (db)
  (if (endp db)
      (ys-txt (grab-lyrics))
      (loop
        (let* ((now (local-time:now))
               (hour (local-time:timestamp-hour now))
               (minute (local-time:timestamp-minute now)))
          (when (and (= hour *hour*) (= minute *minute*))
            (chirp:statuses/update (first *lyrics-db*))
            (ys-txt (rest db)))))))
