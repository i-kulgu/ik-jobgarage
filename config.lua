Config = {}

Config.viewcoords = vector3(454.75, -1020.45, 28.32)

Config.spawnloc = {
    coords = vector3(455.45, -1023.67, 28.46),
    heading = 49.96
}

Config.Pedlocation = {
    {Cords = vector3(459.04, -1017.28, 27.16), h = 91.99}  -- NPC Spawn Location.
}


Config.Garage = {
    spawn = vector3(459.04708, -1017.191, 28.15582),
    out = vector3(451.67, -1019.81, 28.42),
    list = {
        ["01"] = {
            model = "politiefiets",
            label = "Politie Fiets",
            rank = { 0, 1 },
        },
        ["02"] = {
            model = "PolitieMotor",
            label = "Politie Motor",
            rank = { 2, 3, 4, 5 },
        },
        ["03"] = {
            model = "PolitieTouran",
            label = "VW Touran",
            rank = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 },
        },
        ["04"] = {
            model = "PolitieBKlasse",
            label = "Mercedes B Klasse",
            rank = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 },
        },
        ["05"] = {
            model = "PolitieV70",
            label = "Volvo V70",
            rank = { 4, },
        },
        ["06"] = {
            model = "PolitieA6",
            label = "Audi A6",
            rank = { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 },
        },
        ["07"] = {
            model = "PolitieOffroad",
            label = "Ford Offroad",
            rank = { 8, },
        },
        ["08"] = {
            model = "PolitieXC90",
            label = "Volvo XC90",
            rank = { 11, 12, 16, 17, 18 },
        },
        ["09"] = {
            model = "PolitieT6",
            label = "VW T6",
            rank = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 },
        },
        ["10"] = {
            model = "PolitieVito",
            label = "Mercedes Vito",
            rank = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 },
        },
        ["11"] = {
            model = "UPolitiePassat",
            label = "VW Passat (unmarked)",
            rank = { 3, 4, 6, 14, 15 },
        },
        ["12"] = {
            model = "UPolitieArteon",
            label = "VW Arteon (unmarked)",
            rank = { 5, 12, 16, 17, 18 },
        },
        ["13"] = {
            model = "UPolitieA4",
            label = "Audi A4 (unmarked)",
            rank = { 3, 4, 5, 6, 12, 14, 15, 16, 17, 18 },
        },
        ["14"] = {
            model = "UPolitieS4avant",
            label = "Audi S4 Avant (unmarked)",
            rank = { 5, 12, 16, 17, 18 },
        },
        ["15"] = {
            model = "PolitieRS7",
            label = "Audi RS7 (unmarked)",
            rank = { 16, 17, 18 },
        },
        ["16"] = {
            model = "UPolitieTesla",
            label = "Tesla (unmarked)",
            rank = { 16, 17, 18 },
        },
        ["17"] = {
            model = "UPolitieBmw",
            label = "BMW X5 (unmarked)",
            rank = { 5, 12, 15, 16, 17, 18 },
        },
    },
}