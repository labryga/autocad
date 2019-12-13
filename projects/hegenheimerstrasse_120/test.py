import pathlib, json, openpyxl, string

pfad = str(pathlib.Path.home()) + "\Documents\hegenheimerstrasse.json"

with open(pfad) as json_file:
    json_data = json.load(json_file)

entries_list = []

for eintrag in json_data["waende"]:
  for bezeichnung in eintrag.keys():
    if bezeichnung not in  entries_list:
      entries_list.append(bezeichnung)

excel_file = openpyxl.Workbook()
meineseite = excel_file.active

entries_list_index      = 0
column_index = string.ascii_uppercase[:len(entries_list)]

for buchstabe in column_index:
  meineseite[buchstabe + '1'] = entries_list[entries_list_index]
  entries_list_index += 1

zeilen_nummer = 3


for eintrag in json_data["waende"]:

    for bezeichnung in entries_list[:6]:
        meineseite[column_index[entries_list.index(bezeichnung)] + \
            str(zeilen_nummer)] = eintrag[bezeichnung]

    zeilen_nummer += 1

    for exemplar in eintrag["exemplar_nummern"]:
        for bezeichnung in entries_list:

            if not bezeichnung == "bkp-nr":
                try:
                    wert = float(eintrag[bezeichnung])
                except:
                    wert = eintrag[bezeichnung]
            else:
                wert = eintrag[bezeichnung]

            meineseite[column_index[entries_list.index(bezeichnung)] + \
                str(zeilen_nummer)] = (wert,
                                         eintrag["wandtyp"] + "-" + exemplar) \
                                        [bezeichnung == "exemplar_nummern"]

            _cell = meineseite[column_index[entries_list.index(bezeichnung)] + str(zeilen_nummer)]
            try:
                _cell.number_format = "0.00 \"m²\""
            except:
                pass

        zeilen_nummer += 1

    meineseite.insert_rows(idx=zeilen_nummer)
    zeilen_nummer += 1


excel_file.save(str(pathlib.Path.home()) + "\Documents\excel_file.xlsx")
