local QBCore = exports['qb-core']:GetCoreObject()
local cam
local veh

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

AddEventHandler('onClientResourceStart',function()
    Citizen.CreateThread(function()
        while true do
            if QBCore ~= nil and QBCore.Functions.GetPlayerData ~= nil then
                QBCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job then
                        PlayerJob = PlayerData.job
                    end
                end)
                break
            end
            Citizen.Wait(500)
        end
        Citizen.Wait(500)
    end)
end)

local function SetCarItemsInfo()
	local items = {}
	for k, v in pairs(Garage) do
        for l, m in pairs(v.CarItems) do
            local itemInfo = QBCore.Shared.Items[m.name:lower()]
            items[m.slot] = {
                name = itemInfo["name"],
                amount = tonumber(m.amount),
                info = m.info,
                label = itemInfo["label"],
                description = itemInfo["description"] and itemInfo["description"] or "",
                weight = itemInfo["weight"],
                type = itemInfo["type"],
                unique = itemInfo["unique"],
                useable = itemInfo["useable"],
                image = itemInfo["image"],
                slot = m.slot,
            }
        end
	end
	Config.CarItems = items
end

local function PerformanceUpgradeVehicle(vehicle)
    local max
    local mods = {}
    for k,v in pairs(Garage) do
        if v.CarMods.engine then
            mods[#mods+1] = 11
        end
        if v.CarMods.brakes then
            mods[#mods+1] = 12
        end
        if v.CarMods.gearbox then
            mods[#mods+1] = 13
        end
        if v.CarMods.armour then
            mods[#mods+1] = 14
        end
        if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
            for _,modType in pairs(mods) do
                max = GetNumVehicleMods(vehicle, modType) - 1
                SetVehicleMod(vehicle, modType, max, false)
            end
            if v.CarMods.turbo then
                ToggleVehicleMod(vehicle, 18, true)
            end
        end
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(Garage) do
        local hash = GetHashKey(v.pedhash)
        if not HasModelLoaded(hash) then
            RequestModel(hash)
            Wait(10)
        end
        while not HasModelLoaded(hash) do
            Wait(10)
        end
        npc = CreatePed(5, hash, vector3(v.pedlocation.x,v.pedlocation.y,v.pedlocation.z), v.pedlocation.w, false, false)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetEntityInvincible(npc, true) --Don't let the ped die.
        TaskStartScenarioInPlace(npc, "WORLD_HUMAN_CLIPBOARD", 0, true)
        exports['qb-target']:AddBoxZone("npc"..k, vector3(v.pedlocation.x,v.pedlocation.y,v.pedlocation.z), 0.8, 0.6, {
            name = "npc"..k, heading=v.pedlocation.w, debugPoly=false, minZ=v.pedlocation.z - 2, maxZ=v.pedlocation.z + 2,}, {
            options = {{ type = "client", event = "ik-jobgarage:openUI", garage = k,camcoords = v.camcoords,viewcoords = v.viewcoords, icon = 'fas fa-garage', label = 'Police Garage', job = v.jobname }},
            distance = 1.5,})
    end
end)

function openUI(data,index,cb)
    local plyPed = PlayerPedId()
    SetEntityVisible(plyPed, false)
    SetNuiFocus(true, true)
end

RegisterNUICallback("showVeh", function(data,cb)
    local gar = data.garage
    local pos = Garage[gar].viewcoords
    if DoesEntityExist(veh) then
        DeleteEntity(veh)
        while DoesEntityExist(veh) do Wait(250) end

    end
    RequestModel(data.model)
    while not HasModelLoaded(data.model) do Wait(100) end
    veh = CreateVehicle(data.model, pos.x, pos.y, pos.z, 62.03, false, false)
    SetVehicleDirtLevel(veh, 0)
    SetVehicleModKit(veh, 0)
    SetVehicleExtra(veh, 1)
    SetVehicleExtra(veh, 2)
end)

RegisterNetEvent("ik-jobgarage:client:spawn",function(model, pos, garage)
    local ped = PlayerPedId()
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(100) end
    QBCore.Functions.SpawnVehicle(model,function(veh)
        TaskWarpPedIntoVehicle(ped, veh, -1)
        SetVehicleDirtLevel(veh, 0)
        local nummer = math.random(1111,9999)
        local plate = Garage[garage].plateprefix..""..nummer
        SetVehicleNumberPlateText(veh, plate)
        exports[Config.fuelsystem]:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
        SetEntityHeading(veh, Garage[garage].spawnheading)
        SetVehicleEngineOn(veh, true, true)
        SetVehicleModKit(veh, 0)
        if Config.CustomLivery then
            SetVehicleLivery(veh, Garage[garage].CarExtras.livery)
        end
        if Config.CustomExtras then
            if Garage[garage].CarExtras.extras ~=  nil then
                QBCore.Shared.SetDefaultVehicleExtras(veh, Garage[garage].CarExtras.extras)
            end
        end
        if Config.UseCarItems then
            SetCarItemsInfo()
            TriggerServerEvent("inventory:server:addTrunkItems", QBCore.Functions.GetPlate(veh), Config.CarItems)
        end
        if Config.MaxMod then
            PerformanceUpgradeVehicle(veh)
        end
    end,pos, true)
end)

RegisterNUICallback("buy", function(data,cb)
    local gar = data.garage
    local pos = Garage[gar].spawnloc
    SendNUIMessage({
        action = 'close'
    })
    TriggerServerEvent('ik-jobgarage:server:takemoney', data, pos)
    SetEntityVisible(PlayerPedId(), true)
    DeleteEntity(veh)
    DoScreenFadeOut(500)
    Wait(500)
    RenderScriptCams(false, false, 1, true, true)
    DestroyAllCams(true)
    SetNuiFocus(false, false)
    DoScreenFadeIn(500)
    Wait(500)
    if Config.savecar then
        TriggerEvent('ik-jobgarage:client:SaveCar')
    end
end)

RegisterNetEvent('ik-jobgarage:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    while veh == nil do Wait(100) end
    if veh ~= nil and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        if QBCore.Shared.Vehicles[vehname] ~= nil and next(QBCore.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('ik-jobgarage:server:SaveCarData', props, QBCore.Shared.Vehicles[vehname], hash, plate)
        else
            QBCore.Functions.Notify('You cant store this vehicle in your garage..', 'error')
        end
    else
        QBCore.Functions.Notify('You are not in a vehicle..', 'error')
    end
end)

RegisterNUICallback("close", function()
    SetEntityVisible(PlayerPedId(), true)
    DeleteEntity(veh)
    DoScreenFadeOut(500)
    Wait(500)
    RenderScriptCams(false, false, 1, true, true)
    DestroyAllCams(true)
    SetNuiFocus(false, false)
    DoScreenFadeIn(500)
    Wait(500)
end)

RegisterNetEvent("ik-jobgarage:openUI",function(data)
    local gar = data.garage
    local viewcoord = data.viewcoords
    local camcoord = data.camcoords
    local vehlist = {}
    changeCam(viewcoord, camcoord)
    for k, v in pairs(Garage[gar].list) do
		if v.rank then
            for _, b in pairs(v.rank) do
                if b == PlayerJob.grade.level then
                    if Config.enablepayment then
                        local vehicle = {label = v.label, model = v.model, price = v.price, pricing = true, garage = gar}
                        vehlist[#vehlist+1] = vehicle
                    else
                        local vehicle = {label = v.label, model = v.model, pricing = false, garage = gar}
                        vehlist[#vehlist+1] = vehicle
                    end
                end
            end
		end
        SendNUIMessage({
            action = true,
            vehicleInfo = vehlist
        })
        openUI(vehlist, i)
	end
end)

function changeCam(viewcoord, camcoord)
    DoScreenFadeOut(500)
    Wait(1000)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    SetCamActive(cam, true)
    SetCamRot(cam,vector3(-10.0,0.0, -155.999), true)
    SetCamFov(cam,80.0)
    SetCamCoord(cam, camcoord)
    PointCamAtCoord(cam, viewcoord)
    RenderScriptCams(true, false, 2500.0, true, true)
    DoScreenFadeIn(1000)
    Wait(1000)

end