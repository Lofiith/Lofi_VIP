---@class VipFeatures
VipFeatures = VipFeatures or {}

local activeEffects = {}

-- Feature Functions
local function openSkinMenu()
    local menuOptions = {
        'illenium-appearance', 'qb-clothing', 'esx_skin', 'skinchanger',
        'fivem-appearance', 'codem-appearance', 'ag_appearance'
    }
    
    local targetMenu = Config.SkinMenu
    
    if targetMenu == 'auto' then
        for _, menuResource in pairs(menuOptions) do
            if GetResourceState(menuResource) == 'started' then
                targetMenu = menuResource
                break
            end
        end
    end
    
    local success = false
    
    if targetMenu == 'illenium-appearance' and GetResourceState('illenium-appearance') == 'started' then
        TriggerEvent('illenium-appearance:client:openClothingShopMenu')
        success = true
    elseif targetMenu == 'qb-clothing' and GetResourceState('qb-clothing') == 'started' then
        TriggerEvent('qb-clothing:client:openMenu')
        success = true
    elseif targetMenu == 'esx_skin' and GetResourceState('esx_skin') == 'started' then
        TriggerEvent('esx_skin:openSaveableMenu')
        success = true
    elseif targetMenu == 'skinchanger' and GetResourceState('skinchanger') == 'started' then
        TriggerEvent('skinchanger:openMenu')
        success = true
    elseif targetMenu == 'fivem-appearance' and GetResourceState('fivem-appearance') == 'started' then
        exports['fivem-appearance']:startPlayerCustomization()
        success = true
    elseif targetMenu == 'codem-appearance' and GetResourceState('codem-appearance') == 'started' then
        TriggerEvent('codem-appearance:openMenu')
        success = true
    elseif targetMenu == 'ag_appearance' and GetResourceState('ag_appearance') == 'started' then
        TriggerEvent('ag_appearance:openMenu')
        success = true
    end
    
    if not success then
        lib.notify({
            title = 'VIP System',
            description = 'No supported skin menu found',
            type = 'error'
        })
    end
end

local function repairVehicle()
    local vehicle = cache.vehicle
    
    if not vehicle then
        lib.notify({
            title = 'VIP System',
            description = 'You must be in a vehicle',
            type = 'error'
        })
        return false
    end
    
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    lib.notify({
        title = 'VIP System',
        description = 'Vehicle fully repaired!',
        type = 'success'
    })
    return true
end

local function washVehicle()
    local vehicle = cache.vehicle
    
    if not vehicle then
        lib.notify({
            title = 'VIP System',
            description = 'You must be in a vehicle',
            type = 'error'
        })
        return false
    end
    
    SetVehicleDirtLevel(vehicle, 0.0)
    WashDecalsFromVehicle(vehicle, 1.0)
    
    lib.notify({
        title = 'VIP System',
        description = 'Vehicle washed!',
        type = 'success'
    })
    return true
end

local function healPlayer()
    local ped = cache.ped
    
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    
    if GetResourceState('esx_status') == 'started' then
        TriggerEvent('esx_status:set', 'hunger', 1000000)
        TriggerEvent('esx_status:set', 'thirst', 1000000)
    end
    
    lib.notify({
        title = 'VIP System',
        description = 'Health fully restored!',
        type = 'success'
    })
    return true
end

local function giveArmor()
    local ped = cache.ped
    
    SetPedArmour(ped, 100)
    
    lib.notify({
        title = 'VIP System',
        description = 'Armor restored to 100%!',
        type = 'success'
    })
    return true
end

local function toggleGodMode(duration)
    local ped = cache.ped
    
    if activeEffects.godMode then
        lib.notify({
            title = 'VIP System',
            description = 'God mode is already active',
            type = 'error'
        })
        return false
    end
    
    SetEntityInvincible(ped, true)
    activeEffects.godMode = true
    
    lib.notify({
        title = 'VIP System',
        description = ('God mode activated for %d seconds!'):format(duration),
        type = 'success'
    })
    
    local timer = lib.timer(duration * 1000, function()
        if activeEffects.godMode then
            SetEntityInvincible(ped, false)
            activeEffects.godMode = false
            lib.notify({
                title = 'VIP System',
                description = 'God mode deactivated',
                type = 'inform'
            })
        end
    end, true)
    
    return true
end

local function toggleInvisibility(duration)
    local ped = cache.ped
    
    if activeEffects.invisible then
        lib.notify({
            title = 'VIP System',
            description = 'Invisibility is already active',
            type = 'error'
        })
        return false
    end
    
    SetEntityVisible(ped, false, false)
    SetEntityAlpha(ped, 0, false)
    activeEffects.invisible = true
    
    lib.notify({
        title = 'VIP System',
        description = ('Invisibility activated for %d seconds!'):format(duration),
        type = 'success'
    })
    
    local timer = lib.timer(duration * 1000, function()
        if activeEffects.invisible then
            SetEntityVisible(ped, true, false)
            SetEntityAlpha(ped, 255, false)
            activeEffects.invisible = false
            lib.notify({
                title = 'VIP System',
                description = 'Invisibility deactivated',
                type = 'inform'
            })
        end
    end, true)
    
    return true
end

-- Notification event
RegisterNetEvent('lofi_vip:notify', function(data)
    lib.notify(data)
end)

-- Register events only once per resource instance
if not VipFeatures.eventsRegistered then
    VipFeatures.eventsRegistered = true
    
    RegisterNetEvent('lofi_vip:heal', function(price)
        if healPlayer() and price > 0 then
            TriggerServerEvent('lofi_vip:chargeMoney', price)
        end
    end)

    RegisterNetEvent('lofi_vip:armor', function(price)
        if giveArmor() and price > 0 then
            TriggerServerEvent('lofi_vip:chargeMoney', price)
        end
    end)

    RegisterNetEvent('lofi_vip:vehicle_repair', function(price)
        if repairVehicle() and price > 0 then
            TriggerServerEvent('lofi_vip:chargeMoney', price)
        end
    end)

    RegisterNetEvent('lofi_vip:vehicle_wash', function(price)
        if washVehicle() and price > 0 then
            TriggerServerEvent('lofi_vip:chargeMoney', price)
        end
    end)

    RegisterNetEvent('lofi_vip:clothing_menu', function(price)
        openSkinMenu()
        if price > 0 then
            TriggerServerEvent('lofi_vip:chargeMoney', price)
        end
    end)

    RegisterNetEvent('lofi_vip:god_mode', function(duration, price)
        if toggleGodMode(duration) and price > 0 then
            TriggerServerEvent('lofi_vip:chargeMoney', price)
        end
    end)

    RegisterNetEvent('lofi_vip:invisible', function(duration, price)
        if toggleInvisibility(duration) and price > 0 then
            TriggerServerEvent('lofi_vip:chargeMoney', price)
        end
    end)

    RegisterNetEvent('lofi_vip:teleportToCoords', function(coords)
        local ped = cache.ped
        
        DoScreenFadeOut(500)
        Wait(500)
        
        SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
        
        Wait(500)
        DoScreenFadeIn(500)
    end)
end

-- Resource stop cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == cache.resource then
        local ped = cache.ped
        
        if activeEffects.godMode then
            SetEntityInvincible(ped, false)
        end
        
        if activeEffects.invisible then
            SetEntityVisible(ped, true, false)
            SetEntityAlpha(ped, 255, false)
        end
    end
end)

VipFeatures.openSkinMenu = openSkinMenu
VipFeatures.repairVehicle = repairVehicle
VipFeatures.washVehicle = washVehicle
VipFeatures.healPlayer = healPlayer
VipFeatures.giveArmor = giveArmor
VipFeatures.toggleGodMode = toggleGodMode
VipFeatures.toggleInvisibility = toggleInvisibility
