---@class Framework
local Framework = {}

local function detectFramework()
    if Config.Framework == 'standalone' then
        return 'standalone'
    elseif Config.Framework ~= 'auto' then
        return Config.Framework
    end
    
    if GetResourceState('es_extended') == 'started' then
        return 'esx'
    elseif GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started' then
        return 'qbcore'
    else
        return 'standalone'
    end
end

Framework.type = detectFramework()

if Framework.type == 'esx' then
    Framework.object = exports['es_extended']:getSharedObject()
elseif Framework.type == 'qbcore' then
    Framework.object = exports['qb-core']:GetCoreObject() or exports['qbx_core']:GetCoreObject()
end

function Framework.getPlayer(playerId)
    if not playerId then return nil end
    
    if Framework.type == 'esx' then
        return Framework.object.GetPlayerFromId(playerId)
    elseif Framework.type == 'qbcore' then
        return Framework.object.Functions.GetPlayer(playerId)
    else
        return {
            source = playerId,
            identifier = GetPlayerIdentifiers(playerId)[1],
            getName = function() return GetPlayerName(playerId) end,
            getMoney = function() return 50000 end,
            removeMoney = function() return true end,
            addMoney = function() return true end,
            addInventoryItem = function() return true end,
            removeInventoryItem = function() return true end
        }
    end
end

function Framework.getPlayerData()
    if IsDuplicityVersion() then return nil end
    
    if Framework.type == 'esx' then
        return Framework.object.GetPlayerData()
    elseif Framework.type == 'qbcore' then
        return Framework.object.Functions.GetPlayerData()
    else
        return {
            source = GetPlayerServerId(PlayerId()),
            identifier = 'standalone',
            money = { cash = 50000 }
        }
    end
end

function Framework.showNotification(message, notifType)
    if IsDuplicityVersion() then return end
    
    lib.notify({
        title = 'VIP System',
        description = message,
        type = notifType or 'inform'
    })
end

function Framework.registerUsableItem(item, callback)
    if Framework.type == 'esx' then
        Framework.object.RegisterUsableItem(item, callback)
    elseif Framework.type == 'qbcore' then
        Framework.object.Functions.CreateUseableItem(item, callback)
    end
end

_G.Framework = Framework

return Framework
