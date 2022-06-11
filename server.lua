local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('ik-policegarage:server:takemoney', function(data)
    xPlayer = QBCore.Functions.GetPlayer(source)
    if Config.enablepayment then
        if xPlayer.PlayerData.money['cash'] >= data.price then
            xPlayer.Functions.RemoveMoney('cash', data.price)
            TriggerClientEvent('ik-policegarage:client:spawn', source, data.model)
        elseif xPlayer.PlayerData.money['bank'] >= data.price then
            xPlayer.Functions.RemoveMoney('bank', data.price)
            TriggerClientEvent('ik-policegarage:client:spawn', source, data.model)
        else
            TriggerClientEvent('QBCore:Notify', src, "You don't have enough money", 'error', 3000)
        end
    else
        TriggerClientEvent('ik-policegarage:client:spawn', source, data.model)
    end
end)

RegisterServerEvent('ik-policegarage:server:SaveCarData', function(mods, vehicle, hash, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = exports.oxmysql:executeSync('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    if result[1] == nil then
        exports.oxmysql:insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            vehicle.model,
            vehicle.hash,
            json.encode(mods),
            plate,
            0
        })
        TriggerClientEvent('QBCore:Notify', src, 'The vehicle is now yours!', 'success', 5000)
    else
        TriggerClientEvent('QBCore:Notify', src, 'This vehicle is already yours..', 'error', 3000)
    end
end)
