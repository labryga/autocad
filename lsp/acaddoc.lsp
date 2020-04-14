(vl-load-com)

(setq script_list (list 
                    "00_dev"
                    "01_dev"
                    "01_main"
                    "02_dimensions"
                    "05_modify"
                    "06_layer"
                  );list
);setq

(foreach script script_list
         (load script)
);foreach

(load "lehrabschluss_2020/lehrabschluss_2020")

; (load "00_dev")
; (load "01_dev")
; (load "01_main")
; (load "05_modify")
; (load "02_dimensions")
