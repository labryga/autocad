

; function to set dimension with specified alignment and style
(defun c:c(/ alias)

  ; get alias string
  (setq alias (getstring))

  (setq dimalignment (substr alias 1 1))
  (setq dimstyle (substr alias 2 1))

  ; dimstyle list mapped to alias' second character
  (setq dimstyle_list '(
            ("a" "MST 050 [m]") 
            ("s" "MST 050 [cm]") 
            ("q" "MST 100 [m]")
            ("w" "MST 100 [cm]")
            ))

  ; get dimstyle according to alias
  (setq dimstyle_list_entry (assoc dimstyle dimstyle_list ))

  ; set dimstyle by retrieving the dimstyle from list
  (command "-dimstyle" "r" (nth 1 dimstyle_list_entry))

  ; imvoke dim according to alignment
  (if (= dimalignment "d")
    (command "dimlinear")
    (command "dimaligned")
  )
)
