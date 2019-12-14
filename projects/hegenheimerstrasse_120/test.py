import pathlib, json, openpyxl, string

pfad = str(pathlib.Path.home()) + "\Documents\hegenheimerstrasse.json"

with open(pfad) as json_file:
    json_data = json.load(json_file)

entries_list = []

for eintrag in json_data["waende"]:
  for element in eintrag.keys():
    if element not in entries_list:
      entries_list.append(element)

excel_file = openpyxl.Workbook()
meineseite = excel_file.active

entries_list_index      = 0
column_index = string.ascii_uppercase[:len(entries_list)]

for aphanummeric in column_index:
  meineseite[aphanummeric + '1'] = entries_list[entries_list_index]
  entries_list_index += 1

zeilen_nummer = 3


for eintrag in json_data["waende"]:

    for element in entries_list[:6]:
        meineseite[column_index[entries_list.index(element)] + \
            str(zeilen_nummer)] = eintrag[element]

    zeilen_nummer += 1

    for exemplar in eintrag["exemplar_nummern"]:
        for element in entries_list:

            if not element == "bkp-nr":
                try:
                    wert = float(eintrag[element])
                except:
                    wert = eintrag[element]
            else:
                wert = eintrag[element]

            meineseite[column_index[entries_list.index(element)] + \
                str(zeilen_nummer)] = (wert,
                                         eintrag["wandtyp"] + "-" + exemplar) \
                                        [element == "exemplar_nummern"]

            _cell = meineseite[column_index[entries_list.index(element)] + str(zeilen_nummer)]
            try:
                _cell.number_format = "0.00 \"m²\""
            except:
                pass

        zeilen_nummer += 1

    meineseite.insert_rows(idx=zeilen_nummer)
    zeilen_nummer += 1


excel_file.save(str(pathlib.Path.home()) + "\Documents\excel_file.xlsx")
