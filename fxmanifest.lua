fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name 'fynix_crafting'
author 'Fynix'
description 'Crafting System'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependency 'ox_lib'