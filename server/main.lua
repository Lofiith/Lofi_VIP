-- Commands
lib.addCommand(Config.Commands.vipmenu, {
    help = 'Open VIP menu',
    restricted = false
}, function(playerId)
    TriggerClientEvent('lofi_vip:openMenu', playerId)
end)

lib.addCommand(Config.Commands.vipstatus, {
    help = 'Check your VIP status',
    restricted = false
}, function(playerId)
    local hasVip = DiscordAPI.hasVipRole(playerId, 'vip')
    local hasVipPlus = DiscordAPI.hasVipRole(playerId, 'vip_plus')
    local statusText = hasVipPlus and 'VIP+' or (hasVip and 'VIP' or 'No VIP access')
    
    TriggerClientEvent('lofi_vip:notify', playerId, {
        title = 'VIP System',
        description = ('Your status: %s'):format(statusText),
        type = 'inform'
    })
end)

lib.addCommand(Config.Commands.viprefresh, {
    help = 'Refresh your Discord VIP status',
    restricted = false
}, function(playerId)
    if DiscordAPI.refreshPlayerCache(playerId) then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'Discord status refreshed',
            type = 'success'
        })
    else
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'Discord integration not available',
            type = 'error'
        })
    end
end)

-- Player joining
AddEventHandler('playerJoining', function()
    local playerId = source
    
    SetTimeout(5000, function()
        DiscordAPI.updatePlayerVipState(playerId)
    end)
end)

local EXPECTED_RESOURCE_NAME = 'Lofi_VIP'
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= EXPECTED_RESOURCE_NAME then
    lib.print.error('CRITICAL ERROR: Resource name has been changed!')
    lib.print.error(('Expected: %s | Current: %s'):format(EXPECTED_RESOURCE_NAME, currentResourceName))
    lib.print.error('This resource will NOT function properly with a different name!')
    lib.print.error('Please rename the resource back to: ' .. EXPECTED_RESOURCE_NAME)
    return
end

-- Initialization
CreateThread(function()
    Wait(1000)
    lib.print.info('VIP Server initialized successfully')
    lib.print.info(('Framework detected: %s'):format(Framework.type))
end)

-- Exports
exports('hasVipAccess', function(playerId, level)
    return DiscordAPI.hasVipRole(playerId, level)
end)

exports('updatePlayerVipState', function(playerId)
    return DiscordAPI.updatePlayerVipState(playerId)
end)

exports('refreshPlayerCache', function(playerId)
    return DiscordAPI.refreshPlayerCache(playerId)
end)

exports('getDisplayName', function(playerId)
    return DiscordAPI.getDisplayName(playerId)
end)
