fx_version 'cerulean'
author "proportions"
version "v1.2"
description "Police garage script with rank system"
game "gta5"

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {'server.lua'}

ui_page 'ui/index.html'

files {'ui/*'}