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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Config.Pedlocation) do
			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(v.Cords - pos)
			
			if dist < 40 and pedspawned == false then
				TriggerEvent('ik-policegarge:spawnped',v.Cords,v.h)
				pedspawned = true
			end
			if dist >= 35 then
				pedspawned = false
				DeletePed(npc)
			end
		end
	end
end)

RegisterNetEvent('ik-policegarge:spawnped')
AddEventHandler('ik-policegarge:spawnped',function(coords,heading)
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

RegisterNetEvent("ik-policegarge:client:spawn",function(model,spawnLoc,spawnHeading)
    local ped = PlayerPedId()
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(100) end
    local veh = CreateVehicle(model, Config.spawnloc.coords, Config.spawnloc.heading, true, true)
    SetVehicleExtra(veh, 1)
    SetVehicleExtra(veh, 2)
    SetVehicleExtra(veh, 4)
    SetVehicleExtra(veh, 5)
    SetVehicleExtra(veh, 6)
    SetVehicleExtra(veh, 7)
    SetVehicleDirtLevel(veh, 0)
    SetVehicleNumberPlateText(model, plate)
    exports['LegacyFuel']:SetFuel(veh, 100.0)
    TaskWarpPedIntoVehicle(ped, veh, -1)
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    SetEntityHeading(veh, spawnHeading)
    SetVehicleEngineOn(veh, true, true)
    SetVehicleModKit(veh, 0)

    if Config.UseCarItems then
        SetCarItemsInfo()
        TriggerServerEvent("inventory:server:addTrunkItems", QBCore.Functions.GetPlate(veh), Config.CarItems)
    end
 
end)

RegisterNUICallback("buy", function(data,cb)

    SendNUIMessage({
        action = 'close'
    })
    TriggerServerEvent('ik-policegarge:server:takemoney', data)
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
        TriggerEvent('ik-policegarge:client:SaveCar')
    end
end)

RegisterNetEvent('qb-policegarage:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        if QBCore.Shared.Vehicles[vehname] ~= nil and next(QBCore.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('qb-policegarage:server:SaveCarData', props, QBCore.Shared.Vehicles[vehname], hash, plate)
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

RegisterNetEvent("ik-policegarge:openUI",function()
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

exports['qb-target']:AddBoxZone("npc", vector3(459.0, -1017.27, 28.29), 0.8, 0.6, {
  name = "npc",
  heading=2,
  debugPoly=false,
  minZ=27.94,
  maxZ=28.99
}, {
  options = { 
    { 
      type = "client", 
      event = "ik-policegarge:openUI",
      icon = 'fas fa-garage',
      label = 'Police Garage',
      job = 'police'
    }
  },
  distance = 1.5,
})

