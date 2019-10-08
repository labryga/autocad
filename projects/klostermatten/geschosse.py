raume_normgeschoss = {1: "Korridor",
                      2: "Bad",
                      3: "Küche",
                      4: "Wohnen",
                      5: "Zimmer",
                      6: "Zimmer"}

with open("raumliste.csv", "w") as raumliste:

    for geschoss in range(15):
        raumliste.write("OG {:02d}\n\n".format(geschoss))
        for wohnung in range(1, 5):
            raumliste.write("Wohnung {:02d}{}\n\n".format(geschoss, wohnung))
            for raumnummer, raumname in raume_normgeschoss.items():
                if wohnung in [3,4] and raumnummer == 6: continue
                raumliste.write("{:02d}{}.{:02d}\t{}\n".format(geschoss,
                                                           wohnung,
                                                           raumnummer,
                                                           raumname))
            raumliste.write("\n")


