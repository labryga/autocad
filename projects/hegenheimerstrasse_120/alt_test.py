import pathlib, json, openpyxl, string

pfad = str(pathlib.Path.home()) + "\Documents\hegenheimerstrasse.json"

with open(pfad) as json_file:
    data = json.load(json_file)


print(data)
