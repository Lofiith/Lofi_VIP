---@type table
Config = {}

-- Framework Detection: 'auto', 'esx', 'qbcore', 'standalone'
-- Auto will detect framework automatically in priority order: ESX -> QBCore -> Standalone
Config.Framework = 'auto'

-- Skin Menu Detection: 'auto' or specific menu name
-- Auto will detect available skin menus in priority order
-- Supported: 'illenium-appearance', 'qb-clothing', 'esx_skin', 'skinchanger', 'fivem-appearance', 'codem-appearance', 'ag_appearance'
Config.SkinMenu = 'auto'

-- Discord Integration Settings
-- Requires lofi_discord resource for role verification
Config.Discord = {
    vipRoles = {
        '1348940524089905174',  -- Regular VIP role ID
        '1348940524089905174'   -- VIP+ role ID (update with actual role ID)
    }
}

-- Menu Configuration
Config.Menu = {
    title = 'VIP Menu',
    subtitle = 'Exclusive features for VIP members',
    position = 'top-right',
    keybind = {
        name = 'vip_menu',
        key = 'F5',                 -- Keybind to open menu
        description = 'Open VIP Menu'
    }
}

-- VIP Feature Configuration
-- Each feature can be enabled/disabled and configured independently
-- vipLevel: 'vip' for regular VIP, 'vip_plus' for VIP+ exclusive features
Config.Features = {
    heal = {
        enabled = true,
        price = 500,              -- Cost in money
        cooldown = 300,           -- Cooldown in seconds
        vipLevel = 'vip',         -- Required VIP level
        title = 'Full Heal',
        description = 'Restore health to 100%',
        icon = 'heart'
    },
    armor = {
        enabled = true,
        price = 750,
        cooldown = 300,
        vipLevel = 'vip',
        title = 'Full Armor',
        description = 'Restore armor to 100%',
        icon = 'shield-alt'
    },
    vehicle_repair = {
        enabled = true,
        price = 1000,
        cooldown = 600,
        vipLevel = 'vip',
        title = 'Repair Vehicle',
        description = 'Fully repair current vehicle',
        icon = 'wrench'
    },
    vehicle_wash = {
        enabled = true,
        price = 200,
        cooldown = 120,
        vipLevel = 'vip',
        title = 'Wash Vehicle',
        description = 'Clean current vehicle',
        icon = 'soap'
    },
    clothing_menu = {
        enabled = true,
        price = 0,
        cooldown = 60,
        vipLevel = 'vip',
        title = 'Clothing Menu',
        description = 'Access clothing customization',
        icon = 'tshirt'
    },
    -- VIP+ Exclusive Features
    god_mode = {
        enabled = true,
        price = 2000,
        cooldown = 1800,          -- 30 minutes
        duration = 300,           -- 5 minutes of god mode
        vipLevel = 'vip_plus',
        title = 'God Mode',
        description = 'Temporary invincibility',
        icon = 'star'
    },
    invisible = {
        enabled = true,
        price = 1000,
        cooldown = 1200,          -- 20 minutes
        duration = 180,           -- 3 minutes of invisibility
        vipLevel = 'vip_plus',
        title = 'Invisibility',
        description = 'Become invisible to other players',
        icon = 'eye-slash'
    }
}

-- VIP Shop Configuration
-- Currency options: 'money', 'bank', 'black_money' (depends on framework)
Config.Shop = {
    enabled = true,
    title = 'VIP Shop',
    subtitle = 'Exclusive items for VIP members',
    currency = 'money',           -- Payment method
    items = {
        vip = {
            {name = 'bread', label = 'Bread', price = 25, count = 5, icon = 'bread-slice'},
            {name = 'water', label = 'Water Bottle', price = 15, count = 3, icon = 'tint'},
            {name = 'bandage', label = 'Bandage', price = 150, count = 2, icon = 'band-aid'}
        },
        vip_plus = {
            {name = 'bread', label = 'Bread (VIP+ Discount)', price = 12, count = 10, icon = 'bread-slice'},
            {name = 'water', label = 'Water Bottle (VIP+ Discount)', price = 8, count = 5, icon = 'tint'},
            {name = 'bandage', label = 'Bandage (VIP+ Discount)', price = 100, count = 5, icon = 'band-aid'},
            {name = 'lockpick', label = 'Lockpick (VIP+ Exclusive)', price = 500, count = 3, vipLevel = 'vip_plus', icon = 'key'},
            {name = 'repairkit', label = 'Repair Kit (VIP+ Exclusive)', price = 750, count = 1, vipLevel = 'vip_plus', icon = 'tools'}
        }
    }
}

-- Teleport/Quick Travel Configuration
Config.QuickTravel = {
    enabled = true,               -- Enable/disable teleport feature entirely
    vipLevel = 'vip_plus',       -- Required VIP level for teleports
    locations = {
        {name = 'Hospital', coords = vector3(295.87, -1446.94, 29.97), price = 200},
        {name = 'City Hall', coords = vector3(-544.85, -204.13, 38.22), price = 200},
        {name = 'Airport', coords = vector3(-1037.17, -2737.73, 20.17), price = 300},
        {name = 'Beach', coords = vector3(-1393.84, -1020.32, 7.68), price = 250}
    }
}

-- Command Configuration
Config.Commands = {
    vipmenu = 'vipmenu',      -- Open VIP menu
    vipstatus = 'vipstatus',  -- Check VIP status
    viprefresh = 'viprefresh' -- Refresh Discord cache
}
