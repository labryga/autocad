import pathlib, json, openpyxl, string

pfad = str(pathlib.Path.home()) + "\Documents\hegenheimerstrasse.json"

with open(pfad) as json_file:
    data = json.load(json_file)

meineliste = []

for eintrag in data["waende"]:
  for bezeichnung in eintrag.keys():
    if bezeichnung not in  meineliste:
      meineliste.append(bezeichnung)

meinblatt = openpyxl.Workbook()
meineseite = meinblatt.active

meineliste_index      = 0
meineliste_buchstaben = string.ascii_uppercase[:len(meineliste)]

for buchstabe in meineliste_buchstaben:
  meineseite[buchstabe + '1'] = meineliste[meineliste_index]
  meineliste_index += 1

meine_zeilen_nr = 3

for eintrag in data["waende"]:
  for exemplar in eintrag["exemplar_nummern"]:
    for bezeichnung in meineliste:
      meineseite[meineliste_buchstaben[meineliste.index(bezeichnung)] + \
                str(meine_zeilen_nr)] = (str(eintrag[bezeichnung]),
                                         eintrag["wandtyp"] + "-" + str(exemplar)) \
                                        [bezeichnung == "exemplar_nummern"]
    meine_zeilen_nr += 1
  meineseite.insert_rows(idx=meine_zeilen_nr)
  meine_zeilen_nr += 1


meinblatt.save(str(pathlib.Path.home()) + "\Documents\meinblatt.xlsx")
