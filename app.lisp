(in-package :ys-txt)
(in-readtable ys-txt-readtable)

(defun main ()
  (let ((chirp:*oauth-api-key* $YS_API_KEY)
        (chirp:*oauth-api-secret* $YS_API_SECRET)
        (chirp:*oauth-access-token* $YS_ACCESS_TOKEN)
        (chirp:*oauth-access-secret* $YS_ACCESS_SECRET))
    (ys-txt)))

(defun ys-txt ()
  (chirp:statuses/update "wow cool"))
