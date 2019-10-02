
with open("create_dwg_levels.scr", "w") as script_file:

    script_file.write("filedia 0\nqnew\n")

    for i in range(1, 15):
        geschossnumer = "0" + str(i) if len(str(i)) < 2 else str(i)
        script_file.write("save " + \
                          "\"" + \
                          geschossnumer + \
                          "_og.dwg\"\n")

    script_file.write("qsave\nclose\n")
