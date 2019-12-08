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

    for bezeichnung in meineliste[:6]:
        meineseite[meineliste_buchstaben[meineliste.index(bezeichnung)] + \
            str(meine_zeilen_nr)] = eintrag[bezeichnung]

    meine_zeilen_nr += 1

    for exemplar in eintrag["exemplar_nummern"]:
        for bezeichnung in meineliste:

            if not bezeichnung == "bkp-nr":
                try:
                    wert = float(eintrag[bezeichnung])
                except:
                    wert = eintrag[bezeichnung]
            else:
                wert = eintrag[bezeichnung]

            meineseite[meineliste_buchstaben[meineliste.index(bezeichnung)] + \
                str(meine_zeilen_nr)] = (wert,
                                         eintrag["wandtyp"] + "-" + exemplar) \
                                        [bezeichnung == "exemplar_nummern"]

            _cell = meineseite[meineliste_buchstaben[meineliste.index(bezeichnung)] + str(meine_zeilen_nr)]
            try:
                _cell.number_format = "0.00 \"m²\""
            except:
                pass

        meine_zeilen_nr += 1

    meineseite.insert_rows(idx=meine_zeilen_nr)
    meine_zeilen_nr += 1


meinblatt.save(str(pathlib.Path.home()) + "\Documents\meinblatt.xlsx")
