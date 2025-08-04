---@class Features
Features = Features or {}

-- Money Functions
local function getPlayerMoney(playerId, moneyType)
    if not playerId then return 0 end
    
    local player = Framework.getPlayer(playerId)
    if not player then return 0 end
    
    if Framework.type == 'esx' then
        if moneyType == 'bank' then
            return player.getAccount('bank').money
        elseif moneyType == 'black_money' then
            return player.getAccount('black_money').money
        else
            return player.getMoney()
        end
    elseif Framework.type == 'qbcore' then
        if moneyType == 'bank' then
            return player.PlayerData.money.bank
        elseif moneyType == 'black_money' then
            return player.PlayerData.money.crypto or 0
        else
            return player.PlayerData.money.cash
        end
    else
        return 50000
    end
end

local function removePlayerMoney(playerId, amount, moneyType)
    if not playerId or amount <= 0 then return false end
    
    local player = Framework.getPlayer(playerId)
    if not player then return false end
    
    if Framework.type == 'esx' then
        if moneyType == 'bank' then
            player.removeAccountMoney('bank', amount)
        elseif moneyType == 'black_money' then
            player.removeAccountMoney('black_money', amount)
        else
            player.removeMoney(amount)
        end
        return true
    elseif Framework.type == 'qbcore' then
        if moneyType == 'bank' then
            return player.Functions.RemoveMoney('bank', amount)
        elseif moneyType == 'black_money' then
            return player.Functions.RemoveMoney('crypto', amount)
        else
            return player.Functions.RemoveMoney('cash', amount)
        end
    else
        return true
    end
end

local function addPlayerItem(playerId, item, count)
    if not playerId or not item or count <= 0 then return false end
    
    local player = Framework.getPlayer(playerId)
    if not player then return false end
    
    if Framework.type == 'esx' then
        player.addInventoryItem(item, count)
        return true
    elseif Framework.type == 'qbcore' then
        return player.Functions.AddItem(item, count)
    else
        return true
    end
end

function Features.processFeature(playerId, featureName)
    if not playerId or not GetPlayerName(playerId) then return end
    
    local feature = Config.Features[featureName]
    if not feature or not feature.enabled then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'Feature not available',
            type = 'error'
        })
        return
    end
    
    if not DiscordAPI.hasVipRole(playerId, feature.vipLevel) then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'You need ' .. feature.vipLevel:upper():gsub('_', ' ') .. ' access',
            type = 'error'
        })
        return
    end
    
    if Cooldowns.isOnCooldown(playerId, featureName) then
        local remaining = Cooldowns.getCooldownTime(playerId, featureName)
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = ('Cooldown: %d seconds remaining'):format(remaining),
            type = 'warning'
        })
        return
    end
    
    -- Check money but don't charge yet
    if feature.price > 0 then
        local money = getPlayerMoney(playerId, Config.Shop.currency or 'money')
        if money < feature.price then
            TriggerClientEvent('lofi_vip:notify', playerId, {
                title = 'VIP System',
                description = ('Not enough money ($%s required)'):format(feature.price),
                type = 'error'
            })
            return
        end
    end
    
    -- Send to client for validation and execution, client will call back to charge
    local eventName = ('lofi_vip:%s'):format(featureName)
    if feature.duration then
        TriggerClientEvent(eventName, playerId, feature.duration, feature.price)
    else
        TriggerClientEvent(eventName, playerId, feature.price)
    end
    
    -- Set cooldown only after successful execution
    if feature.cooldown > 0 then
        Cooldowns.setCooldown(playerId, featureName, feature.cooldown)
    end
end

-- New function to charge money after client validation
function Features.chargeMoney(playerId, amount)
    if not playerId or not GetPlayerName(playerId) then return false end
    if amount <= 0 then return true end
    
    local money = getPlayerMoney(playerId, Config.Shop.currency or 'money')
    if money < amount then
        return false
    end
    
    return removePlayerMoney(playerId, amount, Config.Shop.currency or 'money')
end

function Features.buyItem(playerId, item)
    if not playerId or not GetPlayerName(playerId) then return end
    if not item or not item.name or not item.price or not item.count then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'Invalid item data',
            type = 'error'
        })
        return
    end
    
    local requiredLevel = item.vipLevel or 'vip'
    
    if not DiscordAPI.hasVipRole(playerId, requiredLevel) then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'You need ' .. requiredLevel:upper():gsub('_', ' ') .. ' access',
            type = 'error'
        })
        return
    end
    
    local money = getPlayerMoney(playerId, Config.Shop.currency or 'money')
    if money < item.price then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = ('Not enough money ($%s required)'):format(item.price),
            type = 'error'
        })
        return
    end
    
    if removePlayerMoney(playerId, item.price, Config.Shop.currency or 'money') then
        if addPlayerItem(playerId, item.name, item.count) then
            TriggerClientEvent('lofi_vip:notify', playerId, {
                title = 'VIP System',
                description = ('Purchased %dx %s'):format(item.count, item.label),
                type = 'success'
            })
        else
            TriggerClientEvent('lofi_vip:notify', playerId, {
                title = 'VIP System',
                description = 'Failed to add item to inventory',
                type = 'error'
            })
        end
    else
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'Transaction failed',
            type = 'error'
        })
    end
end

function Features.teleportToLocation(playerId, location)
    if not playerId or not GetPlayerName(playerId) then return end
    if not location or not location.coords or not location.price then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'Invalid location data',
            type = 'error'
        })
        return
    end
    
    if not DiscordAPI.hasVipRole(playerId, 'vip_plus') then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'You need VIP+ access',
            type = 'error'
        })
        return
    end
    
    local money = getPlayerMoney(playerId, Config.Shop.currency or 'money')
    if money < location.price then
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = ('Not enough money ($%s required)'):format(location.price),
            type = 'error'
        })
        return
    end
    
    if removePlayerMoney(playerId, location.price, Config.Shop.currency or 'money') then
        TriggerClientEvent('lofi_vip:teleportToCoords', playerId, location.coords)
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = ('Teleported to %s'):format(location.name),
            type = 'success'
        })
    else
        TriggerClientEvent('lofi_vip:notify', playerId, {
            title = 'VIP System',
            description = 'Transaction failed',
            type = 'error'
        })
    end
end

-- Register events
if not Features.eventsRegistered then
    Features.eventsRegistered = true
    
    RegisterNetEvent('lofi_vip:useFeature', function(featureName)
        Features.processFeature(source, featureName)
    end)

    RegisterNetEvent('lofi_vip:buyItem', function(item)
        Features.buyItem(source, item)
    end)

    RegisterNetEvent('lofi_vip:teleportToLocation', function(location)
        Features.teleportToLocation(source, location)
    end)
    
    RegisterNetEvent('lofi_vip:chargeMoney', function(amount)
        if Features.chargeMoney(source, amount) then
            TriggerClientEvent('lofi_vip:chargeSuccess', source)
        else
            TriggerClientEvent('lofi_vip:chargeFailed', source)
        end
    end)
end
