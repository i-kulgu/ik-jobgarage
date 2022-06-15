local QBCore = exports['qb-core']:GetCoreObject()
local cam
local lastpos
local veh
local pedspawned = false

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
	for _, item in pairs(Config.CarItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = item.info,
			label = itemInfo["label"],
			description = itemInfo["description"] and itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			slot = item.slot,
		}
	end
	Config.CarItems = items
end

local function PerformanceUpgradeVehicle(vehicle)
    local max
    local mods = {}
    if Config.CarMods.engine then
        mods[#mods+1] = 11
    end
    if Config.CarMods.brakes then
        mods[#mods+1] = 12
    end
    if Config.CarMods.gearbox then
        mods[#mods+1] = 13
    end
    if Config.CarMods.armour then
        mods[#mods+1] = 14
    end
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        for _,modType in pairs(mods) do
            max = GetNumVehicleMods(vehicle, modType) - 1
            SetVehicleMod(vehicle, modType, max, false)
        end
        if Config.CarMods.turbo then
            ToggleVehicleMod(vehicle, 18, true)
        end
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Config.Pedlocation) do
			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(v.Cords - pos)
			
			if dist < 40 and pedspawned == false then
				TriggerEvent('ik-policegarage:spawnped',v.Cords,v.h)
				pedspawned = true
                exports['qb-target']:AddBoxZone("npc"..k, v.Cords, 0.8, 0.6, {
                    name = "npc"..k, heading=v.h, debugPoly=false, minZ=v.Cords.z - 2, maxZ=v.Cords.z + 2,}, {
                    options = {{ type = "client", event = "ik-policegarage:openUI", icon = 'fas fa-garage', label = 'Police Garage', job = 'police' }},
                    distance = 1.5,})
			end
			if dist >= 35 then
			if pedspawned then
					DeletePed(npc)
			pedspawned = false
			end
			end
		end
	end
end)

RegisterNetEvent('ik-policegarage:spawnped')
AddEventHandler('ik-policegarage:spawnped',function(coords,heading)
	local hash = GetHashKey('s_m_y_hwaycop_01')
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		Wait(10)
	end
	while not HasModelLoaded(hash) do 
		Wait(10)
	end

    pedspawned = true
	npc = CreatePed(5, hash, coords, heading, false, false)
	FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityInvincible(npc, true) --Don't let the ped die.

	loadAnimDict("amb@world_human_clipboard@male@base") 
	while not TaskPlayAnim(npc, "amb@world_human_clipboard@male@base", "base", 8.0, 1.0, -1, 17, 0, 0, 0, 0) do
	Wait(1000)
	end
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function openUI(data,index,cb)
    local plyPed = PlayerPedId()
    lastpos = GetEntityCoords(plyPed)
    SetEntityCoords(plyPed, 453.16662, -1024.837, 28.514112)
    SetEntityVisible(plyPed, false)
    SetNuiFocus(true, true)
end

RegisterNUICallback("showVeh", function(data,cb)
    local pos = Config.viewcoords
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

RegisterNetEvent("ik-policegarage:client:spawn",function(model)
    local ped = PlayerPedId()
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(100) end
    QBCore.Functions.SpawnVehicle(model,function(veh)
        TaskWarpPedIntoVehicle(ped, veh, -1)
        SetVehicleDirtLevel(veh, 0)
        local nummer = math.random(1111,9999)
        local plate = Config.plateprefix..""..nummer
        SetVehicleNumberPlateText(veh, plate)
        exports[Config.fuelsystem]:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
        SetEntityHeading(veh, Config.spawnloc.heading)
        SetVehicleEngineOn(veh, true, true)
        SetVehicleModKit(veh, 0)
        if Config.CustomLivery then
            SetVehicleLivery(veh, Config.CarExtras.livery)
        end
        if Config.CustomExtras then
            if Config.CarExtras.extras ~=  nil then
                QBCore.Shared.SetDefaultVehicleExtras(veh, Config.CarExtras.extras)
            end
        end
        if Config.UseCarItems then
            SetCarItemsInfo()
            TriggerServerEvent("inventory:server:addTrunkItems", QBCore.Functions.GetPlate(veh), Config.CarItems)
        end
        if Config.MaxMod then
            PerformanceUpgradeVehicle(veh)
        end
    end,Config.spawnloc.coords, true)
end)

RegisterNUICallback("buy", function(data,cb)

    SendNUIMessage({
        action = 'close'
    })
    TriggerServerEvent('ik-policegarage:server:takemoney', data)
    SetEntityCoords(PlayerPedId(), lastpos.x, lastpos.y, lastpos.z)
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
        TriggerEvent('ik-policegarage:client:SaveCar')
    end
end)

RegisterNetEvent('ik-policegarage:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    while veh == nil do Wait(100) end
    if veh ~= nil and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        if QBCore.Shared.Vehicles[vehname] ~= nil and next(QBCore.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('ik-policegarage:server:SaveCarData', props, QBCore.Shared.Vehicles[vehname], hash, plate)
        else
            QBCore.Functions.Notify('You cant store this vehicle in your garage..', 'error')
        end
    else
        QBCore.Functions.Notify('You are not in a vehicle..', 'error')
    end
end)

RegisterNUICallback("close", function()
    SetEntityCoords(PlayerPedId(), lastpos.x, lastpos.y, lastpos.z)
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

RegisterNetEvent("ik-policegarage:openUI",function()
    local vehlist = {}
    changeCam()
    for k, v in pairs(Config.Garage.list) do
		if v.rank then
            if v.rank then 
                for _, b in pairs(v.rank) do 
                    if b == PlayerJob.grade.level then 
                        if Config.enablepayment then
                            local vehicle = {label = v.label, model = v.model, price = v.price, pricing = true}
                            vehlist[#vehlist+1] = vehicle
                        else
                            local vehicle = {label = v.label, model = v.model, pricing = false}
                            vehlist[#vehlist+1] = vehicle
                        end
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

function changeCam()
    DoScreenFadeOut(500)
    Wait(1000)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    SetCamActive(cam, true)
    SetCamRot(cam,vector3(-10.0,0.0, -155.999), true)
    SetCamFov(cam,80.0)
    SetCamCoord(cam, vector3(451.19, -1014.72, 29.97))
    PointCamAtCoord(cam, vector3(451.19, -1014.72, 29.97))
    RenderScriptCams(true, false, 2500.0, true, true)
    DoScreenFadeIn(1000)
    Wait(1000)

end
