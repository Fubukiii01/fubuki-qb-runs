local QBCore = exports['qb-core']:GetCoreObject()
QBCore.Functions.CreateCallback('fubuki:drugrun:getCops', function(_, cb)
	local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)
