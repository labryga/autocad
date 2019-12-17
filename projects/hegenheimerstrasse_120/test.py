import pathlib, json, openpyxl, string

dateipfad = str(pathlib.Path.home()) + "\Documents\hegenheimerstrasse.json"

with open(dateipfad) as json_file:
    json_data = json.load(json_file)

entries_list = []

for eintrag in json_data["waende"]:
  for wand_element in eintrag.keys():
    if wand_element not in entries_list:
        entries_list.append(wand_element)

excel_file = openpyxl.Workbook()
excel_sheet = excel_file.active

entries_list_index = 0
column_index = string.ascii_uppercase[:len(entries_list)]

for alphabeticals in column_index:
    excel_sheet[alphabeticals + '1'] = entries_list[entries_list_index]
    entries_list_index += 1

zeilen_nummer = 3

for eintrag in json_data["waende"]:

    for wand_element in entries_list[:6]:
        excel_sheet[column_index[entries_list.index(wand_element)] + \
            str(zeilen_nummer)] = eintrag[wand_element]

    zeilen_nummer += 1

    for exemplar in eintrag["exemplar_nummern"]:
        for wand_element in entries_list:

            if not wand_element == "bkp-nr":
                try:
                    cell_value = float(eintrag[wand_element])
                except:
                    cell_value = eintrag[wand_element]
            else:
                cell_value = eintrag[wand_element]

            excel_sheet[column_index[entries_list.index(wand_element)] + \
                str(zeilen_nummer)] = (cell_value,
                                         eintrag["wandtyp"] + "-" + exemplar) \
                                        [wand_element == "exemplar_nummern"]

            _cell_value = excel_sheet[column_index[entries_list.index(wand_element)] + str(zeilen_nummer)]
            try:
                _cell_value.number_format = "0.00 \"m²\""
            except:
                pass

        zeilen_nummer += 1

    excel_sheet.insert_rows(idx=zeilen_nummer)
    zeilen_nummer += 1


excel_file.save(str(pathlib.Path.home()) + "\Documents\excel_file.xlsx")
