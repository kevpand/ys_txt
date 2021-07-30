(in-package :ys-txt)
(in-readtable ys-txt-readtable)

(defparameter *hour* 6)
(defparameter *minute* 50)

(defun grab-lyrics ()
  (alexandria:shuffle
   (remove-if #'(lambda (str) (str:emptyp str))
              (alexandria:flatten
               (let ((files (cl-fad:list-directory "lyrics")))
                 (loop for file in files collect (str:lines (str:from-file file))))))))

(defun ys-txt (lyrics &optional day)
  (if (endp lyrics)
      (ys-txt (grab-lyrics))
      (loop
        (let* ((now (local-time:now))
               (current-day (local-time:timestamp-day now))
               (hour (local-time:timestamp-hour now))
               (minute (local-time:timestamp-minute now)))
          (when (and (or (= current-day 1) (= day current-day))
                     (= hour *hour*)
                     (= minute *minute*))
            (chirp:statuses/update (first lyrics))
            (ys-txt (rest lyrics) (+ current-day 1)))))))

(defun main ()
  (let* ((chirp:*oauth-api-key* $YS_API_KEY)
         (chirp:*oauth-api-secret* $YS_API_SECRET)
         (chirp:*oauth-access-token* $YS_ACCESS_TOKEN)
         (chirp:*oauth-access-secret* $YS_ACCESS_SECRET)
         (local-time:*default-timezone* local-time:+utc-zone+)
         (day (local-time:timestamp-day (local-time:now))))
    (ys-txt (grab-lyrics) 30)))

(in-package :cl-user)

(defun initialize-application (&key port)
  (declare (ignore port))
  (main))
