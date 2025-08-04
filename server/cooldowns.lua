---@class Cooldowns
Cooldowns = Cooldowns or {}

local cooldownData = {}

local function getPlayerIdentifier(playerId)
    if Framework.type == 'esx' then
        local xPlayer = Framework.getPlayer(playerId)
        return xPlayer and xPlayer.identifier or nil
    elseif Framework.type == 'qbcore' then
        local player = Framework.getPlayer(playerId)
        return player and player.PlayerData.citizenid or nil
    else
        local identifiers = GetPlayerIdentifiers(playerId)
        for _, identifier in pairs(identifiers) do
            if identifier:match("steam:") then
                return identifier
            end
        end
        return "source_" .. playerId
    end
end

function Cooldowns.isOnCooldown(playerId, feature)
    local identifier = getPlayerIdentifier(playerId)
    if not identifier then return false end
    
    local key = ("%s:%s"):format(identifier, feature)
    local expiry = cooldownData[key]
    
    if not expiry then return false end
    
    if os.time() >= expiry then
        cooldownData[key] = nil
        return false
    end
    
    return true
end

function Cooldowns.setCooldown(playerId, feature, duration)
    local identifier = getPlayerIdentifier(playerId)
    if not identifier then return end
    
    local key = ("%s:%s"):format(identifier, feature)
    cooldownData[key] = os.time() + duration
end

function Cooldowns.getCooldownTime(playerId, feature)
    local identifier = getPlayerIdentifier(playerId)
    if not identifier then return 0 end
    
    local key = ("%s:%s"):format(identifier, feature)
    local expiry = cooldownData[key]
    
    if not expiry then return 0 end
    
    return math.max(0, expiry - os.time())
end

-- Cleanup cooldowns
if not Cooldowns.cleanupStarted then
    Cooldowns.cleanupStarted = true
    
    CreateThread(function()
        while true do
            Wait(300000) -- 5 minutes
            
            local currentTime = os.time()
            for key, endTime in pairs(cooldownData) do
                if currentTime >= endTime then
                    cooldownData[key] = nil
                end
            end
        end
    end)
end
