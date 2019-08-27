; project specific lisp file

  (setq E41 (list
              "E41-b-211.5-sc-co"
              "E41-b-211.5-sc-sh"
              "E41-b-211.6-sc-co"
              "E41-b-211.6-sc-sh"
              "E41-n-211.5-sc-co"
              "E41-n-211.5-sc-sh"
              "E41-n-211.6-sc-co"
              "E41-n-211.6-sc-sh"
              ))

  (nth layer E41)
)

(defun c:qcf()
  (command "-layer" "s" (getLayer 0) "")
  (command "line")
)

(defun c:qcr()
  (command "-layer" "s" (getLayer 2) "")
  (command "rectang")
)

(defun c:wac()
  (command "rectang")
)
