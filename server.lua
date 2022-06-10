RegisterServerEvent('ik-policegarage:server:takemoney', function(data)
    TriggerClientEvent('ik-policegarage:client:spawn', source, data.model)
end)

