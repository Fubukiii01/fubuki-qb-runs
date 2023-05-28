Config = {}

Config.DevPrints = true  -- True to enable F8 Console prints

Config.Starting = {
    StartingLabel = "Looking for Something?", -- qb-target Label
    StartingPedLocation = vector3(-614.2, 324.08, 81.26), -- Ped Location through which u interact to start heist
    StartingPedLocationHeading = 317.65, -- Ped Heading
    StartingPedsModel = "ig_g" -- Ped Model
}
Config.DrugRunVehicle = "rumpo2" -- Heist Vehicle Model

Config.Cops = {
    Alert = 'Drugvan Interception in Progress', -- Police Alerts
    RequiredCops = 1, -- Required Cops 
    RequireOnDuty = true -- If Cop has to be on-duty to start heist
}

Config.BlacklistedJobs = {
    toggle = false, -- Blocked Jobs Toggle
    message = "I Got Nothing For You!", -- Notify when someone from blocked job try to interact with ped
    [1] = { -- Blocked Jobs
        ["job"] = "police"
    },
    [2] = {
        ["job"] = "ambulance"
    }
}
Config.GlobalTimeout = true -- Set this to true to add a global timeout so no-one else can do the job if someone started it 
Config.ResetTime = 60*60*1000 -- Reset time for Global Timeout and Client Sided timeout

Config.Blips = {
    VehiclePickupBlipSprite = 496, -- Vehicle Blip Sprite
    VehiclePickupBlipScale = 1.0, -- Vehicle Blip Scale 
    VehiclePickupBlipColor = 0, -- Vehicle Blip Color
    VehiclePickupBlipLabel = "Drug Shipment Located", -- Vehicle Blip Label
    VehicleDropOFFBlipSprite = 569, -- Drop Off Blip Sprite
    VehicleDropOFFBlipScale = 1.0, -- Vehicle Blip Scale
    VehicleDropOFFBlipLabel = "Drop Off Location"-- Drop Off Blip Label
}

Config.Mails {
    toggle = true
    [1] = { -- Mail When Player Start Heist
        sender = "G"
        subject = "Drug Shipment Located"
        message = "Drug Shipment Located. Check your GPS!"
    },
    [2] = { -- Mail When Player Gets Dropoff Location
        sender = "G"
        subject = "Dropoff Located"
        message = "Dropoff Location Located. Check your GPS!"
    },
    [3] = { -- Mail When Player Recives Reward Items
        sender = "G"
        subject = "Heist Succesfull"
        message = "Good Job! Get The Good and Leave the Van There For Me"
    },
}

Config.Notify = {
    toggle = true
    [1] = {
        notfication = "Drug Shipment Located. Check your GPS!" -- Notification when player succesfully recives a vehicle pickup location
    },
    [2] = {
        notfication = "Nothing For You Right Now" -- Notification when player try to interact with ped in timeout
    },
    [3] = {
        notfication = "You Don't Have Required Stuff!" -- Notification when player doesn't have required stuff to start heist
    },
    [4] = {
        notfication = "Whats The Fun Without Cops?" -- Notification when not enough cops are in server to start heist
    },
    [5] = {
        notfication = "Security System Disabled" -- Notification when player succesfully hacked the security system
    },
    [6] = {
        notfication = "You Messed Up Try Again" -- Notification when player messed up hacking but there are still tries left
    },
    [7] = {
        notfication = "Good Job! Get The Goods" -- Notification when player succesfully hacked the security system
    },
    [8] = {
        notfication = "You Messed Up Too Many Times" -- Notification when player messed up hacking completely and none tries are left
    },
    [9] = {
        notfication = "Looks Empty" -- Notification when player tries to loot looted van
    },
    [10] = {
        notfication = "Someone Else Is Already On The Job!"  -- Notification when player tries to interact with ped but someone already started the heist and heist is not yet reseted
    },
    [11] = {
        notfication = "You Don't Have Required Stuff!" -- Notification when player doesn't have required stuff to start hacking
    },
}

Config.NoofHackingTries = 2 -- Number of Tries Before Triggering Failed Hacking Events
Config.RequiredItemForHacking = {
    NeedItemForHacking = true, -- True: If u need to have an item in Inventory to Start Hacking | more items can be added by simply using below template
    [1] = {
        ["item"] = "electronickit", -- Item needed
        ["amount"] = 1, 
        ["remove"] = true -- Should Item Be Removed From Inventory
    }
}

Config.OnFootPeds = {
    PedsModel =  "g_m_m_chicold_01", -- On-foot gaurds model 
    PedWeapon = "weapon_carbinerifle", -- On-foot gaurds weapon 
    PedAccuracy = 100,  -- On-foot gaurds accuracy 
    PedHealth = 200, -- On-foot gaurds health (can be 1000 too)  
    PedArmor = 100, -- On-foot gaurds armor
    PedHeadShotDamage = false -- On-foot gaurds should ped suffer headshot damage
}

Config.Pickuplocations = {
    [1] = {
        coords = vector3(195.3301, -1497.174, 29.14161), -- Vehicle Coords 
        heading = 226.83, -- Vehicle Heading
        -- Gaurds Location u can change number of gaurds by simply adding or removing spawn points
        gaurdspawnpoints = {vector4(206.1154, -1498.474, 35.82869, 69.98449), vector4(191.6483, -1508.358, 35.82868, 5.868985), vector4(185.7172, -1501.884, 34.98853, 273.9053), 
        vector4(188.2015, -1496.047, 29.14161, 12.01316), vector4(188.1346, -1485.082, 29.14161, 46.0753), vector4(192.6691, -1503.235, 29.14162, 126.3009)} 
    },
    [2] = {   
        coords = vector3(998.9305, -1562.048, 30.75962), -- Vehicle Coords 
        heading = 178.0429, -- Vehicle Heading
        -- Gaurds Location u can change number of gaurds by simply adding or removing spawn points
        gaurdspawnpoints = {vector4(1005.626, -1565.846, 30.83364, 28.88646), vector4(993.3046, -1554.228, 30.75485, 343.9578), vector4(1005.214, -1527.307, 37.22079, 103.9448), 
        vector4(996.3689, -1577.847, 39.8805, 0.9517991), vector4(992.2934, -1550.857, 36.28189, 7.049345), vector4(991.8911, -1529.512, 30.86456, 194.9327)}
    },
    [3] = {
        coords = vector3(-869.10540771484, 318.38037109375, 83.977699279785), -- Vehicle Coords 
        heading = 176.82055664063,  -- Vehicle Heading
        -- Gaurds Location u can change number of gaurds by simply adding or removing spawn points
        gaurdspawnpoints = {vector4(-864.7924, 320.7859, 85.61667, 161.8954), vector4(-862.4504, 308.9657, 85.66543, 36.72821), vector4(-872.8701, 313.2178, 83.97367, 311.7444) ,
        vector4(-876.4724, 294.4956, 83.97157, 341.5127), vector4(-876.1177, 305.3361, 84.14939, 319.1571), vector4(-1264.163, -863.9709, 22.27577, 17.45502)}
    },
    [4] = {
        coords = vector3(-1275.1856689453, -861.0283203125, 12.21812915802), -- Vehicle Coords 
        heading = 126.36614227295,  -- Vehicle Heading
        -- Gaurds Location u can change number of gaurds by simply adding or removing spawn points
        gaurdspawnpoints = {vector4(-1277.602, -865.3917, 12.21654, 17.62038), vector4(-1280.059, -862.1777, 12.22016, 212.1138), vector4(-1272.588, -857.1757, 12.21709, 291.4348), 
        vector4(-1270.148, -859.8092, 12.22193, 352.6686)}
    },
    [5] = {
        coords = vector3(-1793.201, 396.4202, 112.7916), -- Vehicle Coords 
        heading = 262.6097,  -- Vehicle Heading
        -- Gaurds Location u can change number of gaurds by simply adding or removing spawn points
        gaurdspawnpoints = {vector4(-1796.43, 405.9082, 113.3322, 135.6782), vector4(-1803.25, 388.4828, 112.5952, 64.31499), vector4(-1813.564, 405.013, 117.2927, 181.6665), vector4(-1819.551, 405.7186, 118.5272, 57.0968), 
        vector4(-1804.333, 389.3077, 112.5403, 64.4668), vector4(-1787.679, 405.6312, 113.3097, 114.2824), vector4(-1818.431, 401.9969, 116.47, 184.1978)}
    },
    [6] = {
        coords = vector3(141.37376403809, -243.42581176758, 51.516407012939), -- Vehicle Coords 
        heading = 156.80198669434,  -- Vehicle Heading
        -- Gaurds Location u can change number of gaurds by simply adding or removing spawn points
        gaurdspawnpoints = {vector4(130.301, -240.3802, 60.17667, 220.9006), vector4(153.7585, -244.8695, 56.9024, 103.6053), vector4(152.1226, -250.127, 51.4152, 79.97336), vector4(130.0844, -243.2498, 60.6973, 245.4048)}
    },
}

Config.RequiredItem = { -- Item Requited to start robbery  more items can be added by simply using below template
    [1] = {
        ["item"] = "laptop", -- Item name
        ["amount"] = 1,
        ["remove"] = false -- Should Item Be Removed From Inventory
    },
    [2] = {
        ["item"] = "trojan_usb", -- Item name
        ["amount"] = 1,
        ["remove"] = false -- Should Item Be Removed From Inventory
    },
}

Config.MoneyRelated = { 
    EnableMoneyDrops = true, -- True to enable Unmarked Bills Drops
    MoneyBagAmount =  math.random(1,4) -- Amount of Unmarked Bills to Drop (Default Range: 1 to 4)
} 

Config.Items = { -- Items Received more items can be added by simply using below template
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
    vehspawn = "everytime", ---Mode of Driveby Vehicle to Arive --"everytime" , "none" , "chancebased"
    VehicleModel = "moonbeam2", --Driveby Vehicle
    PedsModelDriver = "a_m_m_soucent_03", -- Driver Model 
    PedsModelPassenger = "a_m_y_juggalo_01", -- Passenger Model
    PedsModelPassenger3 = "cs_taocheng", -- Passenger 3 Model 
    PedsModelPassenger4 = "csb_alan", -- Passenger 4 Model
    Driver_Passenger_Weapon = "weapon_heavypistol", -- Driver and Passenger Weapon
    Passenger3_Passenger4_Weapon = "weapon_carbinerifle_mk2",  -- Passenger 3 and  Passenger 4 Weapon 
    PedAccuracy = 100, -- Peds gaurds accuracy 
    PedHealth = 300, -- Peds health (can be 1000 as well)  
    PedArmor = 100,  -- Peds armor
    PedHeadShotDamage = false -- Peds Should get affected by Headshots or not
}

Config.DropOffLocation = {
    --NPC drive weird sometimes so better to choose a straight lane for drivebycoords | Multiple Vehicle and Peds can be spawned by adding multiple coords to drivebycoords
    [1] = {
        coords = vector3(1189.56, -3105.43, 5.68), -- Location: DOCKS | Vehicle Dropoff Location Coords                                         
        drivebycoords = {vector4(1276.305, -3086.753, 5.905994, 88.58245)} -- Coords to Spawn Driveby Vehicle should be Near Drop Off Location 
    },
    [2] = {
        coords = vector3(-1154.94, -2035.35, 13.16), -- Location: Airport Los Santos | Vehicle Dropoff Location Coords                                                              
        drivebycoords = {} --Map Doesn't Support Driveby 
    },
    [3] = {
        coords = vector3(-289.28, 6302.02, 31.49), -- Location: Paleto | Vehicle Dropoff Location Coords                                                 
        drivebycoords = {vector4(-393.2474, 6306.907, 29.37205, 238.7198)}  -- Coords to Spawn Driveby Vehicle should be Near Drop Off Location
    },
    [4] = {
        coords = vector3(1697.0, 3608.84, 35.35), -- Location: Sandy | Vehicle Dropoff Location Coords                                                  
        drivebycoords = {vector4(1628.309, 3556.686, 35.2361, 297.8438)}  -- Coords to Spawn Driveby Vehicle should be Near Drop Off Location
    },
    [5] = {
        coords = vector3(-53.89, 1950.68, 190.19), -- Location: Sandy Freeway | Vehicle Dropoff Location Coords                                                   
        drivebycoords = {} --Map Doesn't Support Driveby
    },
    [6] = {
        coords = vector3(-105.07, 1010.45, 235.76), -- Location: VineWoord Mansion | Vehicle Dropoff Location Coords                                             
        drivebycoords = {vector4(-112.8008, 905.0027, 235.7114, 21.96997)}  -- Coords to Spawn Driveby Vehicle should be Near Drop Off Location
    },  
}

Config.DiscordLogs = {
    toggle = true, -- To Enable Discord Logs
    color = "2122168", -- Color (By Default: Blue)
    webhook = "", -- Webhook Must Change
    communtiylogo = "" -- Must end with .png or .jpg
}

