---@class DiscordAPI
DiscordAPI = DiscordAPI or {}

local function isDiscordResourceAvailable()
    return GetResourceState('lofi_discord') == 'started'
end

function DiscordAPI.hasVipRole(playerId, requiredLevel)
    if not isDiscordResourceAvailable() then
        return false -- Allow NO access when Discord not available
    end
    
    local vipRoleId = Config.Discord.vipRoles[1]
    local vipPlusRoleId = Config.Discord.vipRoles[2]
    
    if requiredLevel == 'vip_plus' then
        return exports.lofi_discord:hasRole(playerId, vipPlusRoleId)
    elseif requiredLevel == 'vip' then
        return exports.lofi_discord:hasRole(playerId, {vipRoleId, vipPlusRoleId}, false)
    end
    
    return false
end

function DiscordAPI.updatePlayerVipState(playerId)
    if not playerId then return end
    
    local hasVip = DiscordAPI.hasVipRole(playerId, 'vip')
    local hasVipPlus = DiscordAPI.hasVipRole(playerId, 'vip_plus')
    
    local player = Player(playerId)
    if player.state then
        player.state:set('vip', hasVip, true)
        player.state:set('vip_plus', hasVipPlus, true)
    end
end

function DiscordAPI.refreshPlayerCache(playerId)
    if not isDiscordResourceAvailable() then return false end
    
    exports.lofi_discord:refreshCache(playerId)
    DiscordAPI.updatePlayerVipState(playerId)
    return true
end

function DiscordAPI.getDisplayName(playerId)
    if not isDiscordResourceAvailable() then 
        return GetPlayerName(playerId) 
    end
    
    return exports.lofi_discord:getDisplayName(playerId) or GetPlayerName(playerId)
end

-- Initialize Discord connection
if not DiscordAPI.initialized then
    DiscordAPI.initialized = true
    
    CreateThread(function()
        Wait(2000)
        
        if isDiscordResourceAvailable() then
            lib.print.info('Connected to lofi_discord resource')
            
            for _, playerId in pairs(GetPlayers()) do
                DiscordAPI.updatePlayerVipState(tonumber(playerId))
            end
        else
            lib.print.warn('lofi_discord resource not found - VIP system will allow all access')
        end
    end)
end
