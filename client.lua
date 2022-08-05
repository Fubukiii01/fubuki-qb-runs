local QBCore = exports['qb-core']:GetCoreObject()
playerped = PlayerPedId()
local playerJob = nil
randomdropoff = math.random(1, #Config.DropOffLocation)
gaurdtodelete = {}
gaurdtodeletedriveby = {}
timeout = false 


function SetGlobalStatus(boolean) 
    TriggerServerEvent("SetStatus", boolean)
    if Config.DevPrints then 
        print("Set Status", boolean)
    end 
end

function CheckGlobalStatus() 
    TriggerServerEvent("CheckStatus")
end

RegisterNetEvent("GetStatus", function(status)
    GlobalServerStatus = status
end)

Citizen.CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.Starting.StartingPedsModel, {
        options = {
            {
                type = "client",
                event = "fubuki:drugruns:beginingofrun",
                icon = "fa-solid fa-box-archive",
                label = Config.Starting.StartingLabel,
            },
        },
        distance = 1.5,
    })
    loadmodel(Config.Starting.StartingPedsModel)
    StartingPed = CreatePed(4, GetHashKey(Config.Starting.StartingPedsModel), Config.Starting.StartingPedLocation, Config.Starting.StartingPedLocationHeading, 0, 0)
    FreezeEntityPosition(StartingPed, true)
    TaskSetBlockingOfNonTemporaryEvents(StartingPed, true)
    SetEntityInvincible(StartingPed, true)
    SetBlockingOfNonTemporaryEvents(StartingPed, true)
    TaskStartScenarioInPlace(StartingPed, "WORLD_HUMAN_DRUG_DEALER", "Smoke", 0, true)
    SetGlobalStatus(false)
    if Config.DevPrints then 
        print("Ped Spawned | Global Status Stated False | Target Enabled")
    end 
end)

function pickuplocation()
    rabdomloc = math.random(1,#Config.Pickuplocations)
    if Config.DevPrints then 
        print("Random Pickup Location: "..rabdomloc)
    end 
    Setup(Config.Pickuplocations[rabdomloc].coords)
end

RegisterNetEvent('fubuki:drugruns:beginingofrun')
AddEventHandler('fubuki:drugruns:beginingofrun', function()
    loadAnimDict('missfbi3_party_d')
    count = 0
    hackingitemcount = 0
    playerped = PlayerPedId()
    playerJob = QBCore.Functions.GetPlayerData().job
    ishavingblacklistedjob = false 
    if Config.BlacklistedJobs.toggle == true then 
        for i = 1, #Config.BlacklistedJobs do     
            if playerJob.name == Config.BlacklistedJobs[i]["job"] then 
                ishavingblacklistedjob = true 
                if Config.DevPrints then 
                    print("Player Is Having Blacklisted Job")
                end 
            end 
        end 
    end 
    if Config.GlobalTimeout == true then 
        if Config.DevPrints then 
            print("Checking Global Status")
        end 
        CheckGlobalStatus()
    elseif Config.GlobalTimeout == false then 
        if Config.DevPrints then 
            print("Global Status Set False via Config")
        end 
        GlobalServerStatus = false
    end 
    if ishavingblacklistedjob == false then 
        QBCore.Functions.TriggerCallback('fubuki:drugrun:getCops', function(cops)
            if cops >= Config.Cops.RequiredCops then
                if not timeout then
                    if GlobalServerStatus == false then 
                        TaskPlayAnim(playerped, "missfbi3_party_d", 'stand_talk_loop_a_male1',  1.5, -1.5, -1, 0, 0, 0, 0, 0)     
                        Citizen.Wait(6000)    
                        for i = 1, #Config.RequiredItem do 
                            local HasItems = HasItems(Config.RequiredItem[i]["item"], Config.RequiredItem[i]["amount"])
                            if HasItems then 
                                count = count + 1
                            end 
                        end 
                        if count == #Config.RequiredItem then 
                            for i = 1, #Config.RequiredItem do 
                                if Config.RequiredItem[i]["remove"] then 
                                    TriggerServerEvent('QBCore:Server:RemoveItem', Config.RequiredItem[i]["item"], Config.RequiredItem[i]["amount"])
                                end
                            end
                            if Config.DevPrints then 
                                print("Item Obtained")
                            end 
                            RequiredItemObtained = true 
                        else 
                            if Config.DevPrints then 
                                print("Item Removed")
                            end 
                            RequiredItemObtained = false
                        end
                        if RequiredItemObtained then 
                            if Config.DevPrints then 
                                print("Heist Started")
                            end 
                            if Config.Mails.toggle then 
                                TriggerServerEvent('qb-phone:server:sendNewMail', {
                                    sender = Config.Mails[1].sender,
                                    subject =  Config.Mails[1].subject,
                                    message =  Config.Mails[1].message,
                                    button = {}
                                })
                            end 
                            resetheist()
                            if Config.Notify.toggle then 
                                QBCore.Functions.Notify((Config.Notify[1].notfication), "success")
                            end 
                            ClearPedTasksImmediately(playerped)
                            pickuplocation(rabdomloc)
                            timeout = true 
                            nooftries = 1
                            if Config.GlobalTimeout == true then 
                                SetGlobalStatus(true)
                            end 
                        else 
                            if Config.Notify.toggle then 
                                QBCore.Functions.Notify((Config.Notify[3].notfication), "error")
                            end 
                        end 
                    else 
                        if Config.Notify.toggle then 
                            QBCore.Functions.Notify((Config.Notify[10].notfication), "error")
                        end 
                    end 
                else 
                    if Config.Notify.toggle then 
                        QBCore.Functions.Notify((Config.Notify[2].notfication), "error")
                    end 
                end 
            else 
                if Config.Notify.toggle then 
                    QBCore.Functions.Notify((Config.Notify[4].notfication), "error")
                end 
            end 
        end)
    else 
        QBCore.Functions.Notify((Config.BlacklistedJobs.message), "error")
    end 
    Citizen.Wait(Config.ResetTime) 
    if Config.DevPrints then 
        print("Heist Reseted | Global Status Set False | Client Timeout Set False")
    end 
    resetheist()
    SetGlobalStatus(false)
    timeout = false 
end)

function Setup(pickupblipx, pickupblipy, pickupblipz)
    local playerped = PlayerPedId()
    pickupblip = AddBlipForCoord(pickupblipx, pickupblipy, pickupblipz) 
    SetBlipSprite(pickupblip, Config.Blips.VehiclePickupBlipSprite)
    SetBlipDisplay(pickupblip, 2)
    SetBlipScale(pickupblip, Config.Blips.VehiclePickupBlipScale)
    SetBlipColour(pickupblip, Config.Blips.VehiclePickupBlipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blips.VehiclePickupBlipLabel)
    EndTextCommandSetBlipName(pickupblip)
    SetPedRelationshipGroupHash(playerped, GetHashKey("PLAYER"))
    drugruns = true 
    drugrunongoing = true 
    pedoccupiedvehicle = true 
    drugrunsloop = true
    drugrunsmain = true 
    drawtextbool = true 
    alreadylooted = false 
    alreadylootedv2 = false 
    pedsalreadyspawned = false
    drugrunvehiclealreayspawned = false 
    ishavingblacklistedjob = false
    success = nil 
    if Config.DevPrints then 
        print("Script Setup Complete")
    end 
end 

function hintToDisplay(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, 20000)
end

function HasItems(items, amount)
    return QBCore.Functions.HasItem(items, amount)
end

function loadmodel(model)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Citizen.Wait(5)
    end
end 

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function successfunction()
    succesachieved = true
    enginedisabled = true 
    hacksuccess = true 
    exports['qb-core']:HideText()
    if Config.Notify.toggle then 
        QBCore.Functions.Notify((Config.Notify[5].notfication), "success")
    end 
    TaskLeaveVehicle(playerped, vehicledrugrun, 4160)
    for i, v in pairs(gaurdtodelete) do
        if v ~= nil then
            DeleteCreatedPed(v)
        end
    end
    gaurdtodelete = {}
    if Config.DevPrints then 
        print("Hack Successful")
    end 
end 

function notsosuccessfunction()
    nooftries = nooftries + 1
    success = nil 
    RequiredItemObtainedForHacking = false 
    hackingitemcount = 0
    if Config.Notify.toggle then 
        QBCore.Functions.Notify((Config.Notify[6].notfication), "error")
    end 
    for i, v in pairs(gaurdtodelete) do
        if v ~= nil then
            DeleteCreatedPed(v)
        end
    end
    gaurdtodelete = {}
    if Config.DevPrints then 
        print("Hacking Trial Failed")
    end 
end 

function pedsabillities(securitypedss)
    SetPedRelationshipGroupHash(securitypedss, GetHashKey("DrugLords"))
    SetRelationshipBetweenGroups(5, GetHashKey("DrugLords"), GetHashKey("PLAYER"))
    GiveWeaponToPed(securitypedss, GetHashKey(Config.OnFootPeds.PedWeapon), 2000, true, false)
    SetPedAccuracy(securitypedss, Config.OnFootPeds.PedAccuracy)
    SetPedDropsWeaponsWhenDead(securitypedss, false)
    SetPedFleeAttributes(securitypedss, 0, true)
    SetPedCombatRange(securitypedss, 2)
    SetPedCombatMovement(securitypedss, 3)
    SetPedSuffersCriticalHits(securitypedss, Config.OnFootPeds.PedHeadShotDamage)
    SetPedMaxHealth(securitypedss, Config.OnFootPeds.PedHealth)
    SetEntityHealth(securitypedss, Config.OnFootPeds.PedHealth)
    SetPedArmour(securitypedss, Config.OnFootPeds.PedArmor)
    SetPedCombatAttributes(securitypedss, 1424, true) 
    SetPedCombatAttributes(securitypedss, 5, true) 
    SetPedCombatAttributes(securitypedss, 46, true) 
    if Config.DevPrints then 
        print("Ped Spawned With Abillites: "..securitypedss)
    end
end 

function dropofflocationselc()
    randomdropoff = math.random(1,#Config.DropOffLocation)
    if Config.DevPrints then 
        print("Random Drop Off Location: "..randomdropoff)
    end
    waypointmark(Config.DropOffLocation[randomdropoff].coords)
    if Config.Mails.toggle then 
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Mails[2].sender,
            subject =  Config.Mails[2].subject,
            message =  Config.Mails[2].message,
            button = {}
        })
    end 
end 

function waypointmark(dropoutblipx, dropoutblipy, dropoutblipz)
	dropoutblip = AddBlipForCoord(dropoutblipx, dropoutblipy, dropoutblipz)
    SetBlipRoute (dropoutblip, true)
    SetBlipSprite(dropoutblip, Config.Blips.VehicleDropOFFBlipSprite)
    SetBlipScale(dropoutblip, Config.Blips.VehicleDropOFFBlipScale)
    SetBlipAsShortRange(dropoutblip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blips.VehicleDropOFFBlipLabel)
    EndTextCommandSetBlipName(dropoutblip)
end 

function QBCore.Functions.GetClosestVehicle(coords)
    local ped = PlayerPedId()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

pressed = false 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if drugrunsloop then 
            loadmodel(Config.DrugRunVehicle)
            loadmodel(Config.OnFootPeds.PedsModel)
            if not pressed and drugrunongoing then 
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Pickuplocations[rabdomloc].coords, 0) <= 100 then 
                    if not drugrunvehiclealreayspawned then
                        drugrunvehiclealreayspawned = true 
                        ClearAreaOfVehicles(Config.Pickuplocations[rabdomloc].coords, 5, false, false, false, false, false)
                        Citizen.Wait(4000)
                        TriggerServerEvent('fubuki:drugruns:spawnveh') 
                        vehicledrugrun = CreateVehicle(GetHashKey(Config.DrugRunVehicle), Config.Pickuplocations[rabdomloc].coords, Config.Pickuplocations[rabdomloc].heading, 1, 1)
                        pressed = true
                        drugrunongoing = false 
                        drugrunsloop = false 
                        if Config.DevPrints then 
                            print("Vehicle Spawned | Pressed True | DrugRunsGoing True | DrugRunsLoop True | Vehicle Created ")
                        end
                    end 
                    if not pedsalreadyspawned then 
                        pedsalreadyspawned = true
                        for i, v in pairs(Config.Pickuplocations[rabdomloc].gaurdspawnpoints) do
                            local gaurd = CreatePed(28, GetHashKey(Config.OnFootPeds.PedsModel), v.x, v.y, v.z - 1, 0.0, true, true)
                            SetEntityHeading(gaurd, v.w)
                            AddRelationshipGroup("DrugLords")
                            pedsabillities(gaurd)
                            table.insert(gaurdtodelete, gaurd)
                        end
                    end  
                end 

            end 

        end 
    end
end)

function DeleteCreatedPed(variableped)
	if DoesEntityExist(variableped) then 
		SetPedKeepTask(variableped, false)
		TaskSetBlockingOfNonTemporaryEvents(variableped, false)
		ClearPedTasks(variableped)
		TaskWanderStandard(variableped, 10.0, 10)
		SetPedAsNoLongerNeeded(variableped)
		DeletePed(variableped)
        if Config.DevPrints then 
            print("Ped Deleted")
        end
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        if drugrunsmain == true then 
            if IsPedInVehicle(PlayerPedId(), vehicledrugrun, 1) then 
                if pedoccupiedvehicle then  
                    dropofflocationselc()
                    TriggerServerEvent('police:server:policeAlert', Config.Cops.Alert)
                    if Config.DevPrints then 
                        print("Drop Off Location Selected and PD Alert Sent")
                    end
                    Citizen.Wait(1000)
                    pedoccupiedvehicle = false 
                end 
                if DoesBlipExist(pickupblip) then 
                    RemoveBlip(pickupblip)
                    Citizen.Wait(500)
                end 
            end 
        end 
    end 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if drugrunsmain == true then 
            playerpos = GetEntityCoords(PlayerPedId())
            local dist = #(playerpos - Config.DropOffLocation[randomdropoff].coords)
            if dist <= 10 then 
                if IsPedInVehicle(PlayerPedId(), vehicledrugrun, 1) and success == nil then 
                        if inZone ~= true then 
                            inZone = true
                            TriggerEvent('runs:DrawText')
                            if Config.DevPrints then 
                                print("InZone True")
                            end 
                        end
                    if IsControlJustReleased(0, 38) then
                        if Config.DevPrints then 
                            print("Control Pressed")
                        end 
                        if Config.RequiredItemForHacking.NeedItemForHacking then 
                            for i = 1, #Config.RequiredItemForHacking do 
                                local HasItems = HasItems(Config.RequiredItemForHacking[i]["item"], Config.RequiredItemForHacking[i]["amount"])
                                if HasItems then 
                                    hackingitemcount = hackingitemcount + 1
                                end 
                            end 
                            if hackingitemcount == #Config.RequiredItemForHacking then 
                                for i = 1, #Config.RequiredItemForHacking do 
                                    if Config.RequiredItemForHacking[i]["remove"] then 
                                        if Config.DevPrints then 
                                            print("Hacking Item Removed")
                                        end 
                                        TriggerServerEvent('QBCore:Server:RemoveItem', Config.RequiredItemForHacking[i]["item"], Config.RequiredItemForHacking[i]["amount"])
                                    end
                                end
                                RequiredItemObtainedForHacking = true 
                            else 
                                RequiredItemObtainedForHacking = false
                            end
                        else 
                            RequiredItemObtainedForHacking = true 
                        end 
                        if RequiredItemObtainedForHacking then 
                            if nooftries <= Config.NoofHackingTries then 
                                QBCore.Functions.Progressbar('mhacking', 'Installing Hacking Chip', 2000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true
                                    }, {}, {}, {}, function()
                                        if Config.DevPrints then 
                                            print("Hack Event Started")
                                        end
                                        hackingevent()
                                        if DoesBlipExist(dropoutblip) then 
                                            RemoveBlip(dropoutblip)
                                        end 
                                        if DoesBlipExist(pickupblip) then 
                                            RemoveBlip(pickupblip)
                                        end
                                    end, function()
                                    Citizen.Wait(2000)
                                end)
                            else 
                                exports['qb-core']:HideText()
                                if Config.Notify.toggle then 
                                    QBCore.Functions.Notify((Config.Notify[8].notfication), "error")
                                end 
                                enginedisabled = false 
                                hacksuccess = false 
                                TaskLeaveVehicle(playerped, vehicledrugrun, 4160)
                                Citizen.Wait(45000)
                                SetEntityAsNoLongerNeeded(vehicledrugrun)
                                DeleteEntity(vehicledrugrun)
                                pressed = false 
                                enginedisabled = false 
                                if Config.DevPrints then 
                                    print("Hack Failed")
                                end
                                drugrunsmain = false 
                                resetheist()
                            end 
                        else 
                            if Config.Notify.toggle then 
                                QBCore.Functions.Notify((Config.Notify[11].notfication), "error")
                            end 
                        end 
                    end                 
                elseif IsPedInVehicle(PlayerPedId(), vehicledrugrun, 1) == false then 
                        if inZone ~= false then 
                            inZone = false
                            TriggerEvent('runs:DrawText')
                        end
                    end 
                elseif dist > 10 and dist < 18 then 
                    if inZone ~= false then 
                        inZone = false
                        TriggerEvent('runs:DrawText')
                    end
                else
                    inZone = nil
                end 
        end
    end 
end)

RegisterNetEvent('runs:DrawText', function()
    if inZone then
        exports['qb-core']:DrawText('[E] - Start Hacking', 'left')
    elseif inZone == false then
        exports['qb-core']:HideText()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if succesachieved then 
            if enginedisabled and hacksuccess then 
                FreezeEntityPosition(vehicledrugrun, 1)
                if Config.Notify.toggle then 
                    QBCore.Functions.Notify((Config.Notify[7].notfication), "success")
                end 
                hacksuccess = false 
            end 
            local pos = GetEntityCoords(PlayerPedId(), false)
            TruckPos = GetWorldPositionOfEntityBone(vehicledrugrun, GetEntityBoneIndexByName(vehicledrugrun, "door_pside_r"))
            distanceofvan = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, TruckPos.x, TruckPos.y, TruckPos.z, false)
            if distanceofvan <= 2.0 then
                if enginedisabled then 
                    exports['qb-target']:AddTargetEntity(vehicledrugrun, {
                        options = {
                            {
                                type = "client",
                                event = "fubuki:drugruns:reciveitem",
                                icon = "fa-solid fa-circle",
                                label = "Get Package"
                            },
                        },
                        distance = 3.0
                    })
                    if DoesBlipExist(dropoutblip) then 
                        RemoveBlip(dropoutblip)
                    end 
                end 
            end 
        end
    end 
end)

RegisterNetEvent("fubuki:drugruns:reciveitem")
AddEventHandler("fubuki:drugruns:reciveitem", function()
    local playerped = PlayerPedId()
    if not alreadylooted then 
        alreadylooted = true 
        zonalbozo = true 
        drivebyvehcomingchance = math.random(1, 6)
        if Config.DriveByConfiguration.vehspawn == "none" then 
        elseif Config.DriveByConfiguration.vehspawn == "chancebased" then 
            if drivebyvehcomingchance == 6 then 
                if Config.DevPrints then 
                    print("Driveby Peds Spawned")
                end
                TriggerEvent('fubuki:drugruns:drivebypeds')
            end 
        elseif Config.DriveByConfiguration.vehspawn == "everytime" then 
            if Config.DevPrints then 
                print("Driveby Peds Spawned")
            end
            TriggerEvent('fubuki:drugruns:drivebypeds')
        end 
        if Config.DevPrints then 
            print("Item Loot Started")
        end
        ClearPedSecondaryTask(playerped)
        loadAnimDict("veh@break_in@0h@p_m_one@") 
        loadAnimDict("mini@repair")
        loadAnimDict("anim@heists@box_carry@")
        TaskPlayAnim(playerped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds",  1.5, -1.5, -1, 0, 0, 0, 0, 0)
        Citizen.Wait(3000)
        SetVehicleDoorOpen(vehicledrugrun, 2, false)
        SetVehicleDoorOpen(vehicledrugrun, 3, false)
        vehheading = GetEntityHeading(vehicledrugrun)
        SetEntityHeading(playerped, vehheading)
        TaskPlayAnim(playerped, "mini@repair", "fixing_a_player", 1.5, -1.5, -1, 0, 0, 0, 0, 0)
        QBCore.Functions.Progressbar('looting', 'Looting Van', 15000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
            }, {}, {}, {}, function()
                ClearPedTasksImmediately(playerped)
                TriggerEvent('animations:client:EmoteCommandStart', {"box"})
                TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 2.0, 2.0,  -1, 51, 0, false, false, false)
                disableshooting = true 
                dropruns = true 
                alreadylootedv2 = false 
        end, function()
            ClearPedTasksImmediately(playerped)
            Citizen.Wait(500)
        end)
    else 
        if Config.Notify.toggle then 
            QBCore.Functions.Notify((Config.Notify[9].notfication), "error")
        end 
    end 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        if dropruns then
            local pos = GetEntityCoords(PlayerPedId(), false)    
            vehicleInMarker = QBCore.Functions.GetClosestVehicle(pos)
            if vehicleInMarker == vehicledrugrun then 
            else 
                exports['qb-target']:AddTargetEntity(vehicleInMarker, {
                    options = {
                        {
                            type = "client",
                            event = "fubuki:drugruns:takerewards",
                            icon = "fa-solid fa-cannabis",
                            label = "Drop Items",
                            canInteract = function()
                                if disableshooting == false then return false end 
                                if disableshooting == true then return true end 
                            end
                        },
                    },
                    distance = 1.5
                }) 
            end 
        end
    end
end)

RegisterNetEvent("fubuki:drugruns:takerewards")
AddEventHandler("fubuki:drugruns:takerewards", function()
    local playerped = PlayerPedId()
    loadAnimDict('anim@heists@fleeca_bank@scope_out@return_case')
    if not alreadylootedv2 then 
        itemnumber = math.random(1, #Config.Items)
        amount = math.random(Config.Items[itemnumber]["amount"]["min"], Config.Items[itemnumber]["amount"]["max"])
        disableshooting = false 
        dropruns = false 
        alreadylootedv2 = true 
        SetVehicleDoorOpen(vehicleInMarker, 5, false)
        exports("RemoveTargetModel", vehicleInMarker)
        ClearPedTasksImmediately(playerped)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(GetHashKey("hei_prop_heist_box")))
        TaskPlayAnim(playerped, "mini@repair", "fixing_a_player", 1.5, -1.5, -1, 0, 0, 0, 0, 0)
        Citizen.Wait(2000)
        ClearPedTasksImmediately(playerped)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Items[itemnumber]["item"]], "add")
        TriggerServerEvent('QBCore:Server:AddItem', Config.Items[itemnumber]["item"], amount)
        if Config.MoneyRelated.EnableMoneyDrops == true then 
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items['markedbills'], "add")
            TriggerServerEvent('QBCore:Server:AddItem', 'markedbills', Config.MoneyRelated.MoneyBagAmount)
        end
        TaskPlayAnim(playerped, 'anim@heists@fleeca_bank@scope_out@return_case', 'trevor_action', 2.0, 2.0, 5000, 49, 0, 0, 0, 0)    
        Wait(3200)
        SetVehicleDoorShut(vehicleInMarker, 5, false)
        if Config.DiscordLogs.toggle then 
            if Config.DevPrints then 
                print("Discord Logs Sent")
            end
            loot = Config.Items[itemnumber]["item"].."  ** Amount: ** "..amount
            money = Config.MoneyRelated.MoneyBagAmount
            TriggerServerEvent("fubuki:drugruns:discordlogs", loot, money)
        end 
        if Config.Mails.toggle then 
            TriggerServerEvent('qb-phone:server:sendNewMail', {
                sender = Config.Mails[3].sender,
                subject =  Config.Mails[3].subject,
                message =  Config.Mails[3].message,
                button = {}
            })
        end 
        Citizen.Wait(30000)
        DeleteEntity(vehicledrugrun)
        if Config.DevPrints then 
            print("Vehicle Deleted")
        end
        resetheist()
        enginedisabled = false 
        pressed = false 
        drugrunongoing = true
    else 
        if Config.Notify.toggle then 
            QBCore.Functions.Notify((Config.Notify[9].notfication), "error")
        end 
    end 
end)



RegisterNetEvent('fubuki:drugruns:drivebypeds')
AddEventHandler('fubuki:drugruns:drivebypeds', function()
    loadmodel(Config.DriveByConfiguration.VehicleModel)
    loadmodel(Config.DriveByConfiguration.PedsModelDriver)
    loadmodel(Config.DriveByConfiguration.PedsModelPassenger)
    loadmodel(Config.DriveByConfiguration.PedsModelPassenger3)
    loadmodel(Config.DriveByConfiguration.PedsModelPassenger4)
    for i, x in pairs(Config.DropOffLocation[randomdropoff].drivebycoords) do
        AddRelationshipGroup("DrugLords")
        Drivebyvehicle = CreateVehicle(GetHashKey(Config.DriveByConfiguration.VehicleModel), x.x, x.y, x.z, 0.0, true, true)
        driver = CreatePed(26, Config.DriveByConfiguration.PedsModelDriver, x.x, x.y, x.z, 0.0, true, false)
        passenger = CreatePed(26, Config.DriveByConfiguration.PedsModelPassenger, x.x, x.y, x.z, 0.0, true, false)
        passenger2 = CreatePed(26, Config.DriveByConfiguration.PedsModelPassenger3, x.x, x.y, x.z, 0.0, true, false)
        passenger3 = CreatePed(26, Config.DriveByConfiguration.PedsModelPassenger4, x.x, x.y, x.z, 0.0, true, false)
        SetEntityHeading(Drivebyvehicle, x.w)
        drivebypeds(driver, Config.DriveByConfiguration.Driver_Passenger_Weapon, -1, false)
        drivebypeds(passenger, Config.DriveByConfiguration.Driver_Passenger_Weapon, 0, true)
        drivebypeds(passenger2, Config.DriveByConfiguration.Passenger3_Passenger4_Weapon, 1, true)
        drivebypeds(passenger3, Config.DriveByConfiguration.Passenger3_Passenger4_Weapon, 2, true)
        SetEntityCanBeDamaged(Drivebyvehicle, 0)
        SetVehicleModKit(Drivebyvehicle, 0)
        SetVehicleNumberPlateText(Drivebyvehicle, "DRUG5")
        SetVehicleWindowTint(Drivebyvehicle, 2)
        SetVehicleColours(Drivebyvehicle, 0, 0)
        SetVehicleExtraColours(Drivebyvehicle, 0, 0)
        TaskVehicleDriveToCoord(driver, Drivebyvehicle, Config.DropOffLocation[randomdropoff].coords, 10.0, 0, GetHashKey(Config.DriveByConfiguration.VehicleModel), 786603, 1, true)  
        table.insert(gaurdtodeletedriveby, Drivebyvehicle)
        table.insert(gaurdtodeletedriveby, driver)
        table.insert(gaurdtodeletedriveby, passenger)
        table.insert(gaurdtodeletedriveby, passenger2)
        table.insert(gaurdtodeletedriveby, passenger3)
    end 
end)
  
function drivebypeds(drugrunner ,weapon , seat, passenger)
    GiveWeaponToPed(drugrunner, GetHashKey(weapon), 9999, 0, 1)
    SetPedRelationshipGroupHash(drugrunner, GetHashKey("DrugLords"))
    SetPedIntoVehicle(drugrunner, Drivebyvehicle, seat)
    SetPedSuffersCriticalHits(drugrunner, Config.DriveByConfiguration.PedHeadShotDamage)
    SetPedAccuracy(drugrunner, Config.DriveByConfiguration.PedAccuracy)
    SetPedMaxHealth(drugrunner, Config.DriveByConfiguration.PedHealth)
    SetEntityHealth(drugrunner, Config.DriveByConfiguration.PedHealth)
    SetPedArmour(drugrunner, Config.DriveByConfiguration.PedArmor)
    SetPedDropsWeaponsWhenDead(drugrunner, 0)
    if passenger then 
        TaskVehicleShootAtPed(drugrunner, PlayerPedId(), 1)
    end 
    SetRelationshipBetweenGroups(5, GetHashKey("DrugLords"), GetHashKey("PLAYER"))
end


Citizen.CreateThread(function()
    while true do
      Citizen.Wait(500)
        if zonalbozo or lul then 
            if GetDistanceBetweenCoords(GetEntityCoords(Drivebyvehicle), Config.DropOffLocation[randomdropoff].coords, 0) <= 35 then
                Citizen.Wait(200)
                TaskLeaveVehicle(driver, Drivebyvehicle, 262144)
                TaskLeaveVehicle(passenger, Drivebyvehicle, 0)
                TaskLeaveVehicle(passenger2, Drivebyvehicle, 0)
                TaskLeaveVehicle(passenger3, Drivebyvehicle, 0)
                zonalbozo = false 
                Citizen.Wait(100)
                lul = true
                Citizen.Wait(250000)
                if Config.DevPrints then 
                    print("Heist Reset | Driveby Peds Deleted")
                end
                resetheist()
                DeleteVehicle(Drivebyvehicle)
                DeleteEntity(driver)
                DeleteEntity(passenger)
                DeleteEntity(passenger2)
                DeleteEntity(passenger3)
            end 
        end 
    end
end)

function resetheist()
    count = 0
    hackingitemcount = 0
    nooftries = 1
    RequiredItemObtained = false
    RequiredItemObtainedForHacking = false 
    pressed = false
    drugrunsloop = false
    drugrunongoing = false
    drugrunvehiclealreayspawned = false
    pedsalreadyspawned = false
    drugrunsmain = false
    pedoccupiedvehicle = false
    RemoveBlip(dropoutblip)
    RemoveBlip(pickupblip)
    success = somethingbutnotnill
    succesachieved = false
    enginedisabled = false
    hacksuccess = false
    alreadylooted = true 
    zonalbozo = false
    dropruns = false
    disableshooting = false
    ishavingblacklistedjob = false
    alreadylootedv2 = true
    if Config.DevPrints then 
        print("Heist Reset Function()")
    end 
end 


