raume_normgeschoss = {1: {"raumname": "Korridor", 
                          "bodenbelag": 6.24, 
                          "wandbelag": 0},

                      2: {"raumname":"Bad",
                          "bodenbelag": 0,
                          "wandbelag": 0},

                      3: {"raumname":"Küche",
                          "bodenbelag": 0,
                          "wandbelag": 0},

                      4: {"raumname":"Wohnen",
                          "bodenbelag": 0,
                          "wandbelag": 0},

                      5: {"raumname":"Zimmer",
                          "bodenbelag": 0,
                          "wandbelag": 0},

                      6: {"raumname":"Zimmer",
                          "bodenbelag": 0,
                          "wandbelag": 0} }

with open("raumliste.csv", "w") as raumliste:

    for geschoss in range(15):
        raumliste.write("OG,{:02d}\n\n".format(geschoss))
        for wohnung in range(1, 5):
            raumliste.write(",Wohnung,{:02d}{}\n\n".format(geschoss, wohnung))
            for raumnummer, raumname in raume_normgeschoss.items():
                if wohnung in [3,4] and raumnummer == 6: continue
                raumliste.write(",,{:02d}{}.{:02d}\t{}\n".format(geschoss,
                                                           wohnung,
                                                           raumnummer,
                                                           raumname))
            raumliste.write("\n")


