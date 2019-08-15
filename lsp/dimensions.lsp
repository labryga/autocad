
; set global to repeat last command
(setq alias_tmp "")

; function to set dimension with specified alignment and style
(defun c:c(/ alias_string)

  ; get alias string
  (setq alias_string (getstring))


  (if (= alias_tmp "")
    (setq alias_tmp "fq")
    (setq alias_tmp alias_string)
  )

  (setq dimalignment (substr alias_tmp 1 1))
  (setq dimstyle (substr alias_tmp 2 1))

  ; dimstyle list mapped to alias_tmp' second character
  (setq dimstyle_list '(
            ("a" "MST 050 [m]") 
            ("s" "MST 050 [cm]") 
            ("q" "MST 100 [m]")
            ("w" "MST 100 [cm]")
            ))

  ; get dimstyle according to alias_tmp
  (setq dimstyle_list_entry (assoc dimstyle dimstyle_list ))

  ; set dimstyle by retrieving the dimstyle from list
  (command "-dimstyle" "r" (nth 1 dimstyle_list_entry))

  ; setting snap on
  (setvar "autosnap" 63) 
  (setvar "osmode" 35)

  ; invoke dim according to alignment
  (if (= dimalignment "d")
    (command "dimlinear")
    (command "dimaligned")
  )
)
