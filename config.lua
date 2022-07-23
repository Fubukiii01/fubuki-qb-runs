Config = {}
Config.StartingLabel = "Looking for Something?"
Config.HackingWordLimit = math.random(6, 7)
Config.HackingTimeLimit = 40
Config.StartingPedLocation = vector3(-614.2, 324.08, 81.26)
Config.StartingPedLocationHeading = 317.65
Config.StartingPedsModel = "ig_g"
Config.DrugRunVehicle = "rumpo2"
Config.PedWeapon = "weapon_carbinerifle"
Config.Alert = 'Drugvan Interception in Progress'
Config.RequiredCops = 1
Config.RequireOnDuty = true
Config.PedsModel =  "g_m_m_chicold_01"
Config.VehiclePickupBlipSprite = 794
Config.VehiclePickupBlipLabel = "Drug Shipment Located"
Config.VehicleDropOFFBlipSprite = 569
Config.VehicleDropOFFBlipLabel = "Drop Off Location"
Config.DrivebyVeh = "everytime" --"everytime" , "none" , "chancebased"
Config.Notify = {
    [1] = {
        notfication = "Drug Shipment Located. Check your GPS!"
    },
    [2] = {
        notfication = "Complete Previous Shipment First!"
    },
    [3] = {
        notfication = "Don't Mess Around, You Don't Have Required Stuff!"
    },
    [4] = {
        notfication = "Where is The Fun, Not Enough Ops on Duty!"
    },
    [5] = {
        notfication = "Engine Disabled"
    },
    [6] = {
        notfication = "You Messed Up, Leave the Vehicle Here and Run"
    },
    [7] = {
        notfication = "Get To The Back Door and Take Your Reward!"
    },
    [8] = {
        notfication = "Dip! Vehicle Will be taken care by impound employees"
    },
    [9] = {
        notfication = "Already Looting!"
    },
}
Config.Pickuplocations = {
    [1] = {
        coords = vector3(195.3301, -1497.174, 29.14161),
        heading = 226.83,
        gaurdspawnpoints = {vector4(206.1154, -1498.474, 35.82869, 69.98449), vector4(191.6483, -1508.358, 35.82868, 5.868985), vector4(185.7172, -1501.884, 34.98853, 273.9053), 
        vector4(188.2015, -1496.047, 29.14161, 12.01316), vector4(188.1346, -1485.082, 29.14161, 46.0753), vector4(192.6691, -1503.235, 29.14162, 126.3009)}
    },
    [2] = {   
        coords = vector3(998.9305, -1562.048, 30.75962),
        heading = 178.0429,
        gaurdspawnpoints = {vector4(1005.626, -1565.846, 30.83364, 28.88646), vector4(993.3046, -1554.228, 30.75485, 343.9578), vector4(1005.214, -1527.307, 37.22079, 103.9448), 
        vector4(996.3689, -1577.847, 39.8805, 0.9517991), vector4(992.2934, -1550.857, 36.28189, 7.049345), vector4(991.8911, -1529.512, 30.86456, 194.9327)}
    },
    [3] = {
        coords = vector3(-869.10540771484, 318.38037109375, 83.977699279785),
        heading = 176.82055664063,
        gaurdspawnpoints = {vector4(-864.7924, 320.7859, 85.61667, 161.8954), vector4(-862.4504, 308.9657, 85.66543, 36.72821), vector4(-872.8701, 313.2178, 83.97367, 311.7444) ,
        vector4(-876.4724, 294.4956, 83.97157, 341.5127), vector4(-876.1177, 305.3361, 84.14939, 319.1571), vector4(-1264.163, -863.9709, 22.27577, 17.45502)}
    },
    [4] = {
        coords = vector3(-1275.1856689453, -861.0283203125, 12.21812915802),
        heading = 126.36614227295,
        gaurdspawnpoints = {vector4(-1277.602, -865.3917, 12.21654, 17.62038), vector4(-1280.059, -862.1777, 12.22016, 212.1138), vector4(-1272.588, -857.1757, 12.21709, 291.4348), 
        vector4(-1270.148, -859.8092, 12.22193, 352.6686)}
    },
    [5] = {
        coords = vector3(-1793.201, 396.4202, 112.7916),
        heading = 262.6097,
        gaurdspawnpoints = {vector4(-1796.43, 405.9082, 113.3322, 135.6782), vector4(-1803.25, 388.4828, 112.5952, 64.31499), vector4(-1813.564, 405.013, 117.2927, 181.6665), vector4(-1819.551, 405.7186, 118.5272, 57.0968), 
        vector4(-1804.333, 389.3077, 112.5403, 64.4668), vector4(-1787.679, 405.6312, 113.3097, 114.2824), vector4(-1818.431, 401.9969, 116.47, 184.1978)}
    },
    [6] = {
        coords = vector3(141.37376403809, -243.42581176758, 51.516407012939),
        heading = 156.80198669434,
        gaurdspawnpoints = {vector4(130.301, -240.3802, 60.17667, 220.9006), vector4(153.7585, -244.8695, 56.9024, 103.6053), vector4(152.1226, -250.127, 51.4152, 79.97336), vector4(130.0844, -243.2498, 60.6973, 245.4048)}
    },
}
Config.RequiredItem = {
    [1] = {
        ["item"] = "laptop"
    },
    [2] = {
        ["item"] = "trojan_usb"
    },
}

Config.MoneyRelated = {
    EnableMoneyDrops = true 
    MoneyBagAmount =  math.random(1,4)
} 

Config.Items = {
    [1] = {
        ["item"] = "weed_brick",
        ["amount"] = {
            ["min"] = 5,
            ["max"] = 8
        },
    },
    [2] = {
        ["item"] = "coke_small_brick",
        ["amount"] = {
            ["min"] = 3,
            ["max"] = 5
        },
    },
    [3] = {
        ["item"] = "meth",
        ["amount"] = {
            ["min"] = 10,
            ["max"] = 20
        },
    },
}

Config.DriveByConfiguration = {
    VehicleModel = "stockade",
    PedsModelDriver = "a_m_m_soucent_03",
    PedsModelPassenger = "a_m_y_juggalo_01",
    PedsModelPassenger3 = "cs_taocheng",
    PedsModelPassenger4 = "csb_alan",
    Driver_Passenger_Weapon = "weapon_heavypistol",
    Passenger3_Passenger4_Weapon = "weapon_carbinerifle_mk2"
}

Config.DropOffLocation = {
    [1] = {
        coords = vector3(1189.56, -3105.43, 5.68), -- DOCKS
        drivebycoords = {vector4(206.1154, -1498.474, 35.82869, 69.98449)}
    },
    [2] = {
        coords = vector3(-1154.94, -2035.35, 13.16) -- Airport Los Santos
    },
    [3] = {
        coords = vector3(-289.28, 6302.02, 31.49) -- Paleto
    },
    [4] = {
        coords = vector3(1697.0, 3608.84, 35.35) -- Sandy
    },
    [5] = {
        coords = vector3(-53.89, 1950.68, 190.19) -- Sandy Freeway
    },
    [6] = {
        coords = vector3(-105.07, 1010.45, 235.76) -- VineWoord Mansion
    },
}
