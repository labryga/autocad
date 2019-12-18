import pathlib, json, openpyxl, string

# file path relative to os home directory
dateipfad = str(pathlib.Path.home()) + "\Documents\hegenheimerstrasse.json"

with open(dateipfad) as json_file:
    json_data = json.load(json_file)

# collect wall types
wand_typen = []

# read data from jason and append to wall collection
for eintrag in json_data["waende"]:
  for wand_typ in eintrag.keys():
    if wand_typ not in wand_typen:
        wand_typen.append(wand_typ)

excel_file = openpyxl.Workbook()
excel_sheet = excel_file.active


# create alphabetical characters for column index regarding wall type length
column_index = string.ascii_uppercase[:len(wand_typen)]

entries_list_index = 0

# write wall type attributes as headings
for alphabeticals in column_index:
    excel_sheet[alphabeticals + '1'] = wand_typen[entries_list_index]
    entries_list_index += 1

zeilen_nummer = 3

for eintrag in json_data["waende"]:

    for wand_typ in wand_typen[:6]:
        excel_sheet[column_index[wand_typen.index(wand_typ)] + \
            str(zeilen_nummer)] = eintrag[wand_typ]

    zeilen_nummer += 1

    for exemplar in eintrag["exemplar_nummern"]:
        for wand_typ in wand_typen:

            if not wand_typ == "bkp-nr":
                try:
                    cell_value = float(eintrag[wand_typ])
                except:
                    cell_value = eintrag[wand_typ]
            else:
                cell_value = eintrag[wand_typ]

            excel_sheet[column_index[wand_typen.index(wand_typ)] + \
                str(zeilen_nummer)] = (cell_value,
                                         eintrag["wandtyp"] + "-" + exemplar) \
                                        [wand_typ == "exemplar_nummern"]

            _cell_value = excel_sheet[column_index[wand_typen.index(wand_typ)] + str(zeilen_nummer)]
            try:
                _cell_value.number_format = "0.00 \"m²\""
            except:
                pass

        zeilen_nummer += 1

    excel_sheet.insert_rows(idx=zeilen_nummer)
    zeilen_nummer += 1


excel_file.save(str(pathlib.Path.home()) + "\Documents\excel_file.xlsx")
