(load "hegenheimerstrasse_120/modules_lsp/data_extraction_functions.lsp")
(load "hegenheimerstrasse_120/modules_lsp/data_format_functions.lsp")
(load "hegenheimerstrasse_120/modules_lsp/data_export_functions.lsp")

(defun write_attributes ( /
                          insert_selection_set
                          insert_selection_block_entities_list
                          block_next_entity_layer_names_list
                          insert_entities_data
                          insert_entities_data_key_extended
                        )
  (setq 
                                          
    insert_selection_set                  (ssget "x" '((0 . "INSERT")))

    ; iterate over inserts selection and return a list of all corresponding block entities
    ; by a function of data extraction module
    insert_selection_block_entities_list  (get_list_of_insert_block_entities insert_selection_set)

    ; return a list of all corresponding layers of each block entity
    ; by a function of data extraction module
    block_next_entity_layer_names_list    (get_list_of_next_block_entities_layer_names
                                            insert_selection_block_entities_list)
  );setq

  ; create variables for all block entity layers and set/reset to zero
  ; by a function of data extraction module
  (set_next_entity_layer_names_to_variables block_next_entity_layer_names_list)

  ; sum up each next block entities and write to corresponding variable
  (write_next_block_entities_to_variables insert_selection_block_entities_list) 

  (setq

    ; write insert name, insert instances numbers and insert block attributes per insert to list
    insert_entities_data (write_insert_data_to_list
                           insert_selection_set
                           block_next_entity_layer_names_list)

  ; data formatting section

    ; split insert names to list of strings in each insert entry
    insert_entities_data  (split_insert_name_to_list insert_entities_data)

    ; replace "$" and "&" by corresponding "." and "\s" symbols in insert names
    insert_entities_data  (format_characters_in_inserts_data insert_entities_data)

    ; add key values to layer entity names
    insert_entities_data  (extend_instert_data_by_key_values insert_entities_data)
  )

  (write_insert_data_to_json insert_entities_data)

  (princ)

);defun
