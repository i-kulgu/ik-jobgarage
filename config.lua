Config = {}
Config.enablepayment = false -- Change into true to charge for cars
Config.savecar = false -- Change this to true if you want to save the car in database
Config.UseCarItems = false -- Change into true if you want to use trunk items. Look down for Config.CarItems to set up items
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
            price = 0,
        },
        ["02"] = {
            model = "PolitieMotor",
            label = "Politie Motor",
            rank = { 2, 3, 4, 5 },
            price = 0,
        },
        ["03"] = {
            model = "PolitieTouran",
            label = "VW Touran",
            rank = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 },
            price = 0,
        },
        ["04"] = {
            model = "PolitieBKlasse",
            label = "Mercedes B Klasse",
            rank = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 },
            price = 0,
        },
        ["05"] = {
            model = "PolitieV70",
            label = "Volvo V70",
            rank = { 4, },
            price = 0,
        },
        ["06"] = {
            model = "PolitieA6",
            label = "Audi A6",
            rank = { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 },
            price = 0,
        },
        ["07"] = {
            model = "PolitieOffroad",
            label = "Ford Offroad",
            rank = { 8, },
            price = 0,
        },
        ["08"] = {
            model = "PolitieXC90",
            label = "Volvo XC90",
            rank = { 11, 12, 16, 17, 18 },
            price = 0,
        },
        ["09"] = {
            model = "PolitieT6",
            label = "VW T6",
            rank = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 },
            price = 0,
        },
        ["10"] = {
            model = "PolitieVito",
            label = "Mercedes Vito",
            rank = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15 },
            price = 0,
        },
        ["11"] = {
            model = "UPolitiePassat",
            label = "VW Passat (unmarked)",
            rank = { 3, 4, 6, 14, 15 },
            price = 0,
        },
        ["12"] = {
            model = "UPolitieArteon",
            label = "VW Arteon (unmarked)",
            rank = { 5, 12, 16, 17, 18 },
            price = 0,
        },
        ["13"] = {
            model = "UPolitieA4",
            label = "Audi A4 (unmarked)",
            rank = { 3, 4, 5, 6, 12, 14, 15, 16, 17, 18 },
            price = 0,
        },
        ["14"] = {
            model = "UPolitieS4avant",
            label = "Audi S4 Avant (unmarked)",
            rank = { 5, 12, 16, 17, 18 },
            price = 0,
        },
        ["15"] = {
            model = "PolitieRS7",
            label = "Audi RS7 (unmarked)",
            rank = { 16, 17, 18 },
            price = 0,
        },
        ["16"] = {
            model = "UPolitieTesla",
            label = "Tesla (unmarked)",
            rank = { 16, 17, 18 },
            price = 0,
        },
        ["17"] = {
            model = "UPolitieBmw",
            label = "BMW X5 (unmarked)",
            rank = { 5, 12, 15, 16, 17, 18 },
            price = 0,
        },
    },
}

Config.CarItems = {
    [1] = {
        name = "heavyarmor",
        amount = 2,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "empty_evidence_bag",
        amount = 10,
        info = {},
        type = "item",
        slot = 2,
    },
    [3] = {
        name = "police_stormram",
        amount = 1,
        info = {},
        type = "item",
        slot = 3,
    },
}