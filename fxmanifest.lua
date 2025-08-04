fx_version 'cerulean'
game 'gta5'

name 'Lofi VIP System'
description 'Advanced VIP system'
author 'Lofi Development'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/framework.lua'
}

client_scripts {
    'client/features.lua',
    'client/menu.lua',
    'client/main.lua'
}

server_scripts {
    'server/discord.lua',
    'server/cooldowns.lua',
    'server/features.lua',
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'lofi_discord'
}

provides {
    'lofp'
}
