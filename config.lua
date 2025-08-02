Config = {}

Config.Framework = {
    name = "esx_ny", -- "esx_ny", "esx_gammel", "qb", "qbox"
}

Config.Ped = {
    model = 's_m_m_ammucountry',
    position = vector4(1669.43, -25.33, 182.76, 283.56)
}

Config.Adgang = {
    kunBestemteJobs = true, -- Skal der kun være bestemte jobs der kan bruge denne?
    tilladteJobs = {
        "thelost",
        "mafia"
    }
}

Config.Crafting = {
    vaaben = {
        {
            navn = "Pistol",
            item = "weapon_pistol",
            udbytte = 1,
            krav = {
                { item = "metal", antal = 10 },
                { item = "glass", antal = 5 }
            }
        },
        {
            navn = "Pistol .50",
            item = "weapon_pistol50",
            udbytte = 1,
            krav = {
                { item = "metal", antal = 5 },
                { item = "glass", antal = 5 }
            }
        }
    },

    tilbehoer = {
        {
            navn = "50x Pistol Ammunation",
            item = "ammo",
            udbytte = 50,
            krav = {
                { item = "glass", antal = 2 },
                { item = "iron", antal = 4 }
            }
        },
        {
            navn = "Sigte",
            item = "scope",
            udbytte = 1,
            krav = {
                { item = "glass", antal = 2 },
                { item = "iron", antal = 4 }
            }
        },
        {
            navn = "Lyddæmper",
            item = "silencer",
            udbytte = 1,
            krav = {
                { item = "gummi", antal = 3 },
                { item = "metal", antal = 2 }
            }
        }
    }
}
