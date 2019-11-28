; data export functions


; export data to csv file
(defun write_data_to_csv (insert_entities_data /
                          user_home_directory
                          data_file

                          name_list
                          instances_list
                          values_list

                          name
                         )

  (setq user_home_directory (getenv "userprofile")
        data_file (open (strcat user_home_directory "\\Documents\\hegenheimerstrasse.csv") "w")
  );setq

  (foreach eintrag insert_entities_data
           (setq name_list      (reverse (nth 0 eintrag))
                 instances_list (nth 1 eintrag)
                 values_list    (reverse (nth 2 eintrag))

                 name           ""
                 values         ""
           );setq

           (foreach name_index (list 0 1 2 3 4 5 6)
                    (setq name  (strcat (nth name_index name_list) ","
                                        name
                                );strcat
                    );setq
           );foreach
           (write-line name data_file)

           (foreach value values_list
                    (setq values  (strcat
                                    (nth 1 value) ","
                                    values
                                  );strcat
                    );setq
           );foreach

           (foreach instance instances_list
                    (write-line (strcat (nth 0 name_list) "-"
                                        instance ","
                                        values
                                );strcat
                                data_file
                    )
           );foreach

  );foreach

  (close data_file)
  (princ)
);defun


; export data to json file
(defun write_insert_data_to_json  ( insert_data_set
                                    /
                                    json_file
                                    exemplar_nr
                                    file_name_string_list
                                  )
  (setq
    json_file (open (strcat
                      (getenv "userprofile")
                      "\\Documents\\hegenheimerstrasse.json")
                    "w")
    exemplar_nr ""
    file_name_string_list (get_dwg_file_name_string_list)
  );setq

  
    (write-line "{\n" json_file)

      ; write geschosseebene
      (write-line (strcat "\"geschossebene \":" 
                         "\""
                         (nth 0 file_name_string_list)
                         "-"
                        (strcase (nth 1 file_name_string_list))
                         "\"" ",")
                  json_file)

      ; write element type
      (write-line (strcat "\""
                          (nth 2 file_name_string_list)
                          "\":"
                          "[") json_file)

      (foreach item insert_data_set
               (write-line "{" json_file)

               (foreach bezeichnung (nth 0 item)
                        (write-line (strcat "\t\""
                                      (nth 0 bezeichnung) "\": \" "
                                      (nth 1 bezeichnung) "\","
                                    );strcat
                                    json_file
                        )
               );foreach

               (foreach werte (nth 2 item)
                        (write-line (strcat "\t\""
                                      (nth 0 werte) "\": \" "
                                      (nth 1 werte) "\","
                                    );strcat
                                    json_file
                        )
               );foreach

               ; put every value to quotes
               (foreach wert (reverse (nth 1 (nth 1 item)))
                        (setq exemplar_nr (strcat "\"" wert "\"" exemplar_nr
                                          );strcat
                        );setq
               );foreach


               (while (vl-string-search "\"\"" exemplar_nr)
                      (setq exemplar_nr (vl-string-subst "\" , \""  "\"\""  exemplar_nr))
               );while

               (write-line (strcat "\t\"exemplar_nummern\": " "[" exemplar_nr "]") json_file)
               (setq exemplar_nr "")

               (if (=
                     (- (length insert_data_set) 1)
                     (vl-position item insert_data_set))
                   (write-line "}" json_file)
                   (write-line "}," json_file)
               );if

      );foreach

    (write-line "]}" json_file)

  (close json_file)
  (print file_name_string_list)
  (princ)
);defun


; return a list of current dwg file name
(defun get_dwg_file_name_string_list ( / name_string_list)

  (setq name              (getvar "dwgname")
        name_length       (strlen name)
        name_prefix       (substr name 1 (- name_length 4))
        name_string_list  (string_to_list name_prefix "_")
  );setq

  name_string_list
);defun


; split string to list by specified single character seperator
(defun string_to_list ( string_value 
                        seperator /
                        seperator_position)

  (if (setq seperator_position (vl-string-search seperator string_value))

      (cons (substr string_value 1 seperator_position)
            (string_to_list (substr string_value (+ 2 seperator_position))
                            seperator)
      );cons

      (list string_value)
  );if
);defun
