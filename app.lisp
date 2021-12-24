(in-package :ys-txt)

(in-readtable ys-txt-readtable)

(defparameter *hours* '(3 13 17 23))

(defun make-minute ()
  (random 60))

(defun grab-lyrics ()
  (alexandria:shuffle
   (remove-if #'(lambda (str) (str:emptyp str))
              (alexandria:flatten
               (let ((files (cl-fad:list-directory "lyrics")))
                 (loop for file in files collect (str:lines (str:from-file file))))))))

(defun ys-txt (lyrics hours &optional first-run)
  (let ((blessed-minute (make-minute))
        (blessed-hour (first hours)))
    (if (endp lyrics)
        (ys-txt (grab-lyrics) hours)
        (loop
          (if (endp hours)
              (ys-txt lyrics *hours*)
              (let* ((now (local-time:now))
                     (hour (local-time:timestamp-hour now))
                     (minute (local-time:timestamp-minute now)))
                (when (or first-run
                          (and (= hour blessed-hour)
                               (= minute blessed-minute)))
                  (chirp:statuses/update (first lyrics))
                  (ys-txt (rest lyrics) (rest hours)))))))))

(defun main ()
  (let ((chirp:*oauth-api-key* $YS_API_KEY)
        (chirp:*oauth-api-secret* $YS_API_SECRET)
        (chirp:*oauth-access-token* $YS_ACCESS_TOKEN)
        (chirp:*oauth-access-secret* $YS_ACCESS_SECRET)
        (local-time:*default-timezone* local-time:+utc-zone+))
    (ys-txt (grab-lyrics) *hours* t)))
