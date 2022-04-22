fx_version 'cerulean'
game 'gta5'

author 'UnName'
description 'Insertion SQL'
version '1.0.0'

client_script 'client.lua'

server_scripts {
	'server.lua',
	'@mysql-async/lib/MySQL.lua'
}
