---@class VipMenu
VipMenu = VipMenu or {}

local isMenuOpen = false

-- Menu Functions
local function createFeatureButtons()
    local buttons = {}
    
    for featureName, feature in pairs(Config.Features) do
        if feature.enabled then
            buttons[#buttons + 1] = {
                title = feature.title,
                description = feature.description,
                icon = feature.icon,
                metadata = {
                    {label = 'Price', value = ('$%s'):format(feature.price)},
                    {label = 'Cooldown', value = ('%d seconds'):format(feature.cooldown)},
                    {label = 'Required Level', value = feature.vipLevel:upper():gsub('_', ' ')}
                },
                onSelect = function()
                    TriggerServerEvent('lofi_vip:useFeature', featureName)
                end
            }
        end
    end
    
    return buttons
end

local function createShopButtons()
    local buttons = {}
    
    if not Config.Shop.enabled then return buttons end
    
    -- Show all items for simplicity
    for _, item in pairs(Config.Shop.items.vip) do
        buttons[#buttons + 1] = {
            title = item.label,
            description = ('Purchase %dx %s'):format(item.count, item.label),
            icon = item.icon,
            metadata = {
                {label = 'Price', value = ('$%s'):format(item.price)},
                {label = 'Count', value = item.count},
                {label = 'Item', value = item.name}
            },
            onSelect = function()
                TriggerServerEvent('lofi_vip:buyItem', item)
            end
        }
    end
    
    for _, item in pairs(Config.Shop.items.vip_plus) do
        buttons[#buttons + 1] = {
            title = item.label,
            description = ('Purchase %dx %s'):format(item.count, item.label),
            icon = item.icon,
            metadata = {
                {label = 'Price', value = ('$%s'):format(item.price)},
                {label = 'Count', value = item.count},
                {label = 'Item', value = item.name}
            },
            onSelect = function()
                TriggerServerEvent('lofi_vip:buyItem', item)
            end
        }
    end
    
    return buttons
end

local function createTeleportButtons()
    local buttons = {}
    
    if not Config.QuickTravel.enabled then return buttons end
    
    for _, location in pairs(Config.QuickTravel.locations) do
        buttons[#buttons + 1] = {
            title = location.name,
            description = ('Teleport to %s'):format(location.name),
            icon = 'map-marker-alt',
            metadata = {
                {label = 'Price', value = ('$%s'):format(location.price)}
            },
            onSelect = function()
                TriggerServerEvent('lofi_vip:teleportToLocation', location)
            end
        }
    end
    
    return buttons
end

local function openVipMenu()
    if isMenuOpen then 
        lib.hideContext()
        isMenuOpen = false
        return 
    end
    
    isMenuOpen = true
    
    local featureButtons = createFeatureButtons()
    local shopButtons = createShopButtons()
    local teleportButtons = createTeleportButtons()
    
    local options = {}
    
    if #featureButtons > 0 then
        options[#options + 1] = {
            title = 'VIP Features',
            description = 'Access exclusive VIP features',
            icon = 'star',
            menu = 'vip_features'
        }
    end
    
    if #shopButtons > 0 then
        options[#options + 1] = {
            title = 'VIP Shop',
            description = 'Purchase exclusive items',
            icon = 'shopping-cart',
            menu = 'vip_shop'
        }
    end
    
    if #teleportButtons > 0 then
        options[#options + 1] = {
            title = 'Quick Travel',
            description = 'Teleport to locations (VIP+ only)',
            icon = 'plane',
            menu = 'vip_teleport'
        }
    end
    
    lib.registerContext({
        id = 'vip_main',
        title = Config.Menu.title,
        options = options,
        onExit = function()
            isMenuOpen = false
        end
    })
    
    lib.registerContext({
        id = 'vip_features',
        title = 'VIP Features',
        menu = 'vip_main',
        options = featureButtons
    })
    
    lib.registerContext({
        id = 'vip_shop',
        title = 'VIP Shop',
        menu = 'vip_main',
        options = shopButtons
    })
    
    lib.registerContext({
        id = 'vip_teleport',
        title = 'Quick Travel',
        menu = 'vip_main',
        options = teleportButtons
    })
    
    lib.showContext('vip_main')
end

-- Register keybind and events only once per resource instance
if not VipMenu.initialized then
    VipMenu.initialized = true
    
    lib.addKeybind({
        name = Config.Menu.keybind.name,
        description = Config.Menu.keybind.description,
        defaultKey = Config.Menu.keybind.key,
        onPressed = function(self)
            openVipMenu()
        end
    })

    RegisterNetEvent('lofi_vip:openMenu', function()
        openVipMenu()
    end)
end

VipMenu.open = openVipMenu
