(vl-load-com)

(setq script_list (list 
                    "01_main"
                    "02_dimensions"
                    "03_views"
                    "05_modify"
                    "06_layer"
                    "00_dev"
                    "01_dev"
                  );list
);setq

(foreach script_file script_list
         (load script_file)
);foreach


; (load "01_main")
; (load "02_dimensions")
; (load "03_views")
; (load "05_modify")
; (load "00_dev")
; (load "01_dev")
