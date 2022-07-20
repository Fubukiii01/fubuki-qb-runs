local QBCore = exports['qb-core']:GetCoreObject()
playerped = PlayerPedId()
randomdropoff = math.random(1, #Config.DropOffLocation)

timeout = false 
Citizen.CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.StartingPedsModel, {
        options = {
            {
                type = "client",
                event = "fubuki:drugruns:beginingofrun",
                icon = "fa-solid fa-box-archive",
                label = Config.StartingLabel,
            },
        },
        distance = 1.5,
    })
    RequestModel(Config.StartingPedsModel)
    while not HasModelLoaded(Config.StartingPedsModel) do 
        RequestModel(GetHashKey(Config.StartingPedsModel))
        Citizen.Wait(1)
    end
    StartingPed = CreatePed(4, GetHashKey(Config.StartingPedsModel), Config.StartingPedLocation, Config.StartingPedLocationHeading, 0, 0)
    FreezeEntityPosition(StartingPed, true)
    TaskSetBlockingOfNonTemporaryEvents(StartingPed, true)
    SetEntityInvincible(StartingPed, true)
    SetBlockingOfNonTemporaryEvents(StartingPed, true)
    TaskStartScenarioInPlace(StartingPed, "WORLD_HUMAN_DRUG_DEALER", "Smoke", 0, true)
end)

function pickuplocation()
    rabdomloc = math.random(1,#Config.Pickuplocations)
    Setup(Config.Pickuplocations[rabdomloc].coords)
end

RegisterNetEvent('fubuki:drugruns:beginingofrun')
AddEventHandler('fubuki:drugruns:beginingofrun', function()
    item1 = QBCore.Functions.HasItem(Config.RequiredItem[1]["item"], 1)
    item2 = QBCore.Functions.HasItem(Config.RequiredItem[2]["item"], 1)
    QBCore.Functions.TriggerCallback('fubuki:drugrun:getCops', function(cops)
        if cops >= Config.RequiredCops then
            if item1 and item2 then 
                if not timeout then 
                    QBCore.Functions.Notify((Config.Notify[1].notfication), "success")
                    pickuplocation(rabdomloc)
                    timeout = true 
                    TriggerServerEvent('QBCore:Server:RemoveItem', Config.RequiredItem[1]["item"], 1)
                    TriggerServerEvent('QBCore:Server:RemoveItem', Config.RequiredItem[2]["item"], 1)
                else 
                    QBCore.Functions.Notify((Config.Notify[2].notfication), "error")
                end 
            else 
                QBCore.Functions.Notify((Config.Notify[3].notfication), "error")
            end 
        else 
            QBCore.Functions.Notify((Config.Notify[4].notfication), "error")
        end 
    end)
    Citizen.Wait(30000)
    timeout = false 
end)

function Setup(pickupblipx, pickupblipy, pickupblipz)
    local playerped = PlayerPedId()
    pickupblip = AddBlipForCoord(pickupblipx, pickupblipy, pickupblipz) 
    SetBlipSprite(pickupblip, Config.VehiclePickupBlipSprite)
    SetBlipDisplay(pickupblip, 2)
    SetBlipScale(pickupblip, 1.0)
    SetBlipColour(pickupblip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.VehiclePickupBlipLabel)
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
    success = nil 
end 

function hintToDisplay(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, 20000)
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        Citizen.Wait(1)
    end
end

function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
      RequestModel(GetHashKey(model))
      Wait(10)
    end
end

function HackingSuccess(success)
    local playerped = PlayerPedId()
    if success then
        succesachieved = true
        enginedisabled = true 
        hacksuccess = true 
		TriggerEvent('mhacking:hide')
        exports['qb-core']:HideText()
        QBCore.Functions.Notify((Config.Notify[5].notfication), "success")
        TaskLeaveVehicle(playerped, vehicledrugrun, 4160)
        DeleteCreatedPed(gaurd1)
        DeleteCreatedPed(gaurd2)
        DeleteCreatedPed(gaurd3)
        DeleteCreatedPed(gaurd4)
        DeleteCreatedPed(gaurd5)
        DeleteCreatedPed(gaurd6)
    else
		TriggerEvent('mhacking:hide')
        exports['qb-core']:HideText()
        QBCore.Functions.Notify((Config.Notify[6].notfication), "error")
        enginedisabled = false 
        hacksuccess = false 
        TaskLeaveVehicle(playerped, vehicledrugrun, 4160)
        Citizen.Wait(45000)
        SetEntityAsNoLongerNeeded(vehicledrugrun)
        DeleteEntity(vehicledrugrun)
        pressed = false 
        enginedisabled = false 
        DeleteCreatedPed(gaurd1)
        DeleteCreatedPed(gaurd2)
        DeleteCreatedPed(gaurd3)
        DeleteCreatedPed(gaurd4)
        DeleteCreatedPed(gaurd5)
        DeleteCreatedPed(gaurd6)
	end
    drugrunsmain = false
end 


-- function spawnped(blablapeds, pedx, pedy, pedz)
--     blablapeds = CreatePed(4 , GetHashKey(Config.PedsModel), pedx, pedy, pedz, 0.0, true, true)
--     AddRelationshipGroup("DrugLords")
--     pedsabillities(blablapeds)
--     Citizen.Wait(1000)
-- end 

function pedsabillities(securitypedss)
    SetPedRelationshipGroupHash(securitypedss, GetHashKey("DrugLords"))
    SetRelationshipBetweenGroups(5, GetHashKey("DrugLords"), GetHashKey("PLAYER"))
    GiveWeaponToPed(securitypedss, GetHashKey(Config.PedWeapon), 2000, true, false)
    SetPedAccuracy(securitypedss, 100)
    SetPedDropsWeaponsWhenDead(securitypedss, false)
    SetPedFleeAttributes(securitypedss, 0, true)
    SetPedCombatRange(securitypedss, 2)
    SetPedCombatMovement(securitypedss, 3)
    SetPedSuffersCriticalHits(securitypedss, false)
    SetPedMaxHealth(securitypedss, 200)
    SetEntityHealth(securitypedss, 200)
    SetPedArmour(securitypedss, 100)
    -- SetPedAsCop(securitypedss)
    SetPedCombatAttributes(securitypedss, 1424, true) 
    SetPedCombatAttributes(securitypedss, 5, true) 
    SetPedCombatAttributes(securitypedss, 46, true) 
    print("Ped Spawned With Abillites: "..securitypedss)
end 

function dropofflocationselc()
    randomdropoff = math.random(1,#Config.DropOffLocation)
    print(randomdropoff)
    waypointmark(Config.DropOffLocation[randomdropoff].coords)
end 

function waypointmark(dropoutblipx, dropoutblipy, dropoutblipz)
	dropoutblip = AddBlipForCoord(dropoutblipx, dropoutblipy, dropoutblipz)
    SetBlipRoute (dropoutblip, true)
    SetBlipSprite(dropoutblip, Config.VehicleDropOFFBlipSprite)
    SetBlipScale(dropoutblip, 1.0)
    SetBlipAsShortRange(dropoutblip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.VehicleDropOFFBlipLabel)
    EndTextCommandSetBlipName(dropoutblip)
end 

function DrawText3Ds(vehx, vehy, vehz, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(vehx, vehy, vehz, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
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
            RequestModel(GetHashKey(Config.DrugRunVehicle))
            while not HasModelLoaded(GetHashKey(Config.DrugRunVehicle)) do
                RequestModel(GetHashKey(Config.DrugRunVehicle))
                Citizen.Wait(5)
            end
            RequestModel(Config.PedsModel)
            while not HasModelLoaded(Config.PedsModel) do 
                RequestModel(GetHashKey(Config.PedsModel))
                Citizen.Wait(5)
            end
            if not pressed and drugrunongoing then 
                if not drugrunvehiclealreayspawned then
                    drugrunvehiclealreayspawned = true 
                    ClearAreaOfVehicles(Config.Pickuplocations[rabdomloc].coords, 5, false, false, false, false, false)
                    Citizen.Wait(4000)
                    vehicledrugrun = CreateVehicle(GetHashKey(Config.DrugRunVehicle), Config.Pickuplocations[rabdomloc].coords, Config.Pickuplocations[rabdomloc].heading, 1, 1)
                end 
                if not pedsalreadyspawned then 
                    pedsalreadyspawned = true
                    gaurd1 = CreatePed(4 , GetHashKey(Config.PedsModel), Config.Pickuplocations[rabdomloc].locgaurd1, 0.0, true, true)
                    gaurd2 = CreatePed(4 , GetHashKey(Config.PedsModel), Config.Pickuplocations[rabdomloc].locgaurd2, 0.0, true, true)
                    gaurd3 = CreatePed(4 , GetHashKey(Config.PedsModel), Config.Pickuplocations[rabdomloc].locgaurd3, 0.0, true, true)
                    gaurd4 = CreatePed(4 , GetHashKey(Config.PedsModel), Config.Pickuplocations[rabdomloc].locgaurd4, 0.0, true, true)
                    gaurd5 = CreatePed(4 , GetHashKey(Config.PedsModel), Config.Pickuplocations[rabdomloc].locgaurd5, 0.0, true, true)
                    gaurd6 = CreatePed(4 , GetHashKey(Config.PedsModel), Config.Pickuplocations[rabdomloc].locgaurd6, 0.0, true, true)
                    AddRelationshipGroup("DrugLords")
                    pedsabillities(gaurd1)
                    pedsabillities(gaurd2)
                    pedsabillities(gaurd3)
                    pedsabillities(gaurd4)
                    pedsabillities(gaurd5)
                    pedsabillities(gaurd6)
                end  
                pressed = true
                drugrunongoing = false 
            end 
            drugrunsloop = false 
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
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        if drugrunsmain == true then 
            if IsPedInVehicle(PlayerPedId(), vehicledrugrun, 1) then 
                if pedoccupiedvehicle then  
                    dropofflocationselc()
                    TriggerServerEvent('police:server:policeAlert', Config.Alert)
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
            if GetDistanceBetweenCoords(playerpos, Config.DropOffLocation[randomdropoff].coords, 0) <= 10 then 
                if IsPedInVehicle(PlayerPedId(), vehicledrugrun, 1) and success == nil then 
                    exports['qb-core']:DrawText('[E] - Start Hacking', 'left')
                    if IsControlJustReleased(0, 38) then
                        QBCore.Functions.Progressbar("mhacking", ('Installing Hacking Chip'), 2000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        })
                        Citizen.Wait(2000)
                        TriggerEvent("mhacking:show")
                        TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), HackingSuccess)
                        if DoesBlipExist(dropoutblip) then 
                            RemoveBlip(dropoutblip)
                        end 
                        if DoesBlipExist(pickupblip) then 
                            RemoveBlip(pickupblip)
                        end
                    end 
                end 
            else 
                exports['qb-core']:HideText()
            end 
        end
    end 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if succesachieved then 
            if enginedisabled and hacksuccess then 
                FreezeEntityPosition(vehicledrugrun, 1)
                QBCore.Functions.Notify((Config.Notify[7].notfication), "success")
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
                                label = "Get Package",
                            },
                        },
                        distance = 3.0
                    })
                    if DoesBlipExist(dropoutblip) then 
                        RemoveBlip(dropoutblip)
                    end 
                end 
            end 
           -- succesachieved = false 
        end
    end 
end)

RegisterNetEvent("fubuki:drugruns:reciveitem")
AddEventHandler("fubuki:drugruns:reciveitem", function()
    local playerped = PlayerPedId()
    if not alreadylooted then 
        alreadylooted = true 
        ClearPedSecondaryTask(playerped)
        loadAnimDict("veh@break_in@0h@p_m_one@") 
        loadAnimDict("mini@repair")
        loadAnimDict("anim@heists@box_carry@")
        QBCore.Functions.Progressbar("looting", ('Looting Van'), 16000, false, true, { --16000
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        })
        TaskPlayAnim(playerped, "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 8.0, -8, -1, 0, 0, 0, 0, 0)
        Citizen.Wait(3000)
        SetVehicleDoorOpen(vehicledrugrun, 2, false)
        SetVehicleDoorOpen(vehicledrugrun, 3, false)
        vehheading = GetEntityHeading(vehicledrugrun)
        SetEntityHeading(playerped, vehheading)
        TaskPlayAnim(playerped, "mini@repair", "fixing_a_player", 1.5, -1.5, -1, 0, 0, 0, 0, 0)
        Citizen.Wait(15500) -- 15500
        ClearPedTasksImmediately(playerped)
        TriggerEvent('animations:client:EmoteCommandStart', {"box"})
        disableshooting = true 
        dropruns = true 
        alreadylootedv2 = false 
    else 
        QBCore.Functions.Notify((Config.Notify[9].notfication), "error")
    end 
end)

RegisterNetEvent("fubuki:drugruns:takerewards")
AddEventHandler("fubuki:drugruns:takerewards", function()
    local playerped = PlayerPedId()
    if not alreadylootedv2 then 
        SetVehicleDoorOpen(vehicleInMarker, 5, 1)
        disableshooting = false 
        dropruns = false 
        alreadylootedv2 = true 
        exports("RemoveTargetModel", vehicleInMarker)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(GetHashKey("hei_prop_heist_box")))
        TaskPlayAnim(playerped, "mini@repair", "fixing_a_player", 1.5, -1.5, -1, 0, 0, 0, 0, 0)
        Citizen.Wait(2000)
        ClearPedTasksImmediately(playerped)
        itemnumber = math.random(1, #Config.Items)
        amount = math.random(Config.Items[itemnumber]["amount"]["min"], Config.Items[itemnumber]["amount"]["max"])
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[Config.Items[itemnumber]["item"]], "add")
        TriggerServerEvent('QBCore:Server:AddItem', Config.Items[itemnumber]["item"], amount)
        QBCore.Functions.Notify((Config.Notify[8].notfication), "success")
        Citizen.Wait(30000)
        SetEntityAsNoLongerNeeded(vehicledrugrun)
        DeleteEntity(vehicledrugrun)
        enginedisabled = false 
        pressed = false 
        drugrunongoing = true
    else 
        QBCore.Functions.Notify((Config.Notify[9].notfication), "error")
    end 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        if dropruns then
            local pos = GetEntityCoords(PlayerPedId(), false)    
            local vehicleInMarker = QBCore.Functions.GetClosestVehicle(pos)
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
end)




-- End of Job Natives
-- pressed = false 
-- drugrunsmain = false 
-- enginedisabled = false 


------------------------------------------------------------------------------------------COMMENTED PARTS---------------------------------------------------------------------------------------------------------
--if GetDistanceBetweenCoords(GetEntityCoords(playerped), Config.Pickuplocations[rabdomloc].locgaurd1, 0) <= 60 then 
--end
--if GetDistanceBetweenCoords(GetEntityCoords(playerped), Config.Pickuplocations[rabdomloc].coords, 0) <= 30 then 
-- end 
--distanceofvan = vector3(0,0,0)
--print("Vehicle Spawned Check 1")
--print(rabdomloc)
--print(Config.DrugRunVehicle)
--print(Config.Pickuplocations[rabdomloc].coords)
--print("Vehicle Exist")
-- Citizen.CreateThread(function()
--         Citizen.Wait(0)
--         RequestModel(GetHashKey(Config.DrugRunVehicle))
--         while not HasModelLoaded(GetHashKey(Config.DrugRunVehicle)) do
--             RequestModel(GetHashKey(Config.DrugRunVehicle))
--             Citizen.Wait(5)
--         end
--         rabdomloc = 2
--         vehicledrugrun = CreateVehicle(GetHashKey(Config.DrugRunVehicle), Config.Pickuplocations[rabdomloc].coords, Config.Pickuplocations[rabdomloc].heading, 1, 1)
--         print("spawn")
--         exports['qb-target']:AddTargetEntity(vehicledrugrun, {
--             options = {
--                 {
--                     type = "client",
--                     event = "fubuki:drugruns:reciveitem",
--                     icon = "fas fa-box-circle-check",
--                     label = "Get Package",
--                 },
--             },
--             distance = 3.0
--         })
-- end)