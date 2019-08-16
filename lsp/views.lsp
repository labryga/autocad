
(defun c:sv(/ alias)

  (setq alias (getstring "\nenter visualstyle: "))

  (setq visualstyles (list 
          (list "a" "w")
          (list "s" "s")
          (list "d" "c")
          (list "f" "x")
          (list "r" "r")
        ))

  (setq visualstyle_entry (assoc alias visualstyles))
  (setq visualstyle (nth 1 visualstyle_entry))

  (command "-visualstyles" "c" visualstyle "" "")

  (princ)
)

