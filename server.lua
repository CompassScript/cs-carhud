RegisterServerEvent("cs-carhud:syncIndicators", function(vehNetId, indicatorState)
    TriggerClientEvent("cs-carhud:syncIndicators", -1, vehNetId, indicatorState)
end)