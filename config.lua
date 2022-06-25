Config = {}
Config.enablepayment = true -- Change into true to charge for cars
Config.savecar = true -- Change this to true if you want to save the car in database
Config.UseCarItems = true -- Change into true if you want to use trunk items. Look down for Config.CarItems to set up items
Config.CustomExtras = true -- Set this true if you want custom car extra's. Look down for Config.CarExtras to set up extras
Config.CustomLivery = false -- Set this true if you want custom livery for your cars. Look down for Config.CarExtras to set up livery
Config.MaxMod = true -- Set this to true if you want your vehicle max modded. Look down for Config.CarMods to enable / disable the desired parts to max mod
Config.fuelsystem = "ps-fuel" -- Set your fuel system, LegacyFuel, ps-fuel or other fuel system

Garage = {
    ["pdhq"] = {
        jobname = "police", -- Job name for this garage
        plateprefix = "POLI", -- Set plate prefix, max 4 letters
        spawnloc = vector4(455.45, -1023.67, 28.46, 49.96), -- Spawn location of the car
        spawnheading = 49.96, -- heading of the car
        viewcoords = vector3(454.75, -1020.45, 28.32), -- cam coordinates
        pedhash = 's_m_y_hwaycop_01', -- ped to be used
        pedlocation = vector4(459.04, -1017.28, 27.16, 91.99), -- location of the ped
        list = { -- list of cars to be used in this garage
            ["01"] = {
                model = "policeb",
                label = "Police Bike",
                rank = { 0, 1 },
                price = 0,
            },
            ["02"] = {
                model = "police",
                label = "Police Car 1",
                rank = { 0, 1, 2 },
                price = 0,
            },
            ["03"] = {
                model = "police2",
                label = "Police Car 2",
                rank = { 0, 1, 2, 3 },
                price = 0,
            },
            ["04"] = {
                model = "police3",
                label = "Police HSU",
                rank = { 3, 4 },
                price = 0,
            },
            ["05"] = {
                model = "police4",
                label = "Police Unmarked",
                rank = { 1, 2, 3, 4 },
                price = 0,
            },
            ["06"] = {
                model = "policet",
                label = "Police Van",
                rank = { 1, 2 },
                price = 0,
            },
            ["07"] = {
                model = "riot",
                label = "Riot",
                rank = { 3, 4 },
                price = 0,
            },
        },
        CarItems = { -- list of items to put inside the vehicles for this garage
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
        },
        CarExtras = { -- Extra options to be enabled / disabled for this garage
            ["extras"] = {
                ["1"] = true, -- on/off
                ["2"] = true,
                ["3"] = true,
                ["4"] = true,
                ["5"] = true,
                ["6"] = true,
                ["7"] = true,
                ["8"] = true,
                ["9"] = true,
                ["10"] = true,
                ["11"] = true,
                ["12"] = true,
                ["13"] = true,
            },
            ["livery"] = 1,
        },
        CarMods = { -- Mods to be enabled / disabled for this garage
            engine = true,
            brakes = true,
            gearbox = true,
            armour = false,
            turbo = true,
        }
    }
}
