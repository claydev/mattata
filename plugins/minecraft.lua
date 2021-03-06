local minecraft = {}
local mattata = require('mattata')
local HTTP = require('socket.http')
local JSON = require('dkjson')

function minecraft:init(configuration)
	minecraft.arguments = 'minecraft <server IP> <port>'
	minecraft.commands = mattata.commands(self.info.username, configuration.commandPrefix):c('minecraft').table
	minecraft.help = configuration.commandPrefix .. 'minecraft <server IP> <port> - Sends information about the given Minecraft server IP.'
end

function minecraft:onMessage(message, language)
	local input = mattata.input(message.text)
	if not input then
		mattata.sendMessage(message.chat.id, minecraft.help, nil, true, false, message.message_id)
		return
	end
	local jstr, res = HTTP.request('http://api.syfaro.net/server/status?ip=' .. input:gsub(' ', '&port=') .. '&players=true&favicon=false')
	if res ~= 200 then
		mattata.sendMessage(message.chat.id, language.errors.connection, nil, true, false, message.message_id)
		return
	end
	local jdat = JSON.decode(jstr)
	local output = '*'..jdat.motd:gsub("§a", ""):gsub("§b", ""):gsub("§c", ""):gsub("§d", ""):gsub("§e", ""):gsub("§f", ""):gsub("§k", ""):gsub("§l", ""):gsub("§m", ""):gsub("§n", ""):gsub("§o", ""):gsub("§r", ""):gsub("§0", ""):gsub("§1", ""):gsub("§2", ""):gsub("§3", ""):gsub("§4", ""):gsub("§5", ""):gsub("§6", ""):gsub("§7", ""):gsub("§8", ""):gsub("§9", ""):gsub("\n", " "):gsub("			 ", " "):gsub("			", " "):gsub("		   ", " "):gsub("		  ", " "):gsub("		 ", " "):gsub("		", " "):gsub("	   ", " "):gsub("	  ", " "):gsub("	 ", " "):gsub("	", " "):gsub("   ", " "):gsub("  ", " "):gsub(" ", " ") .. '*\n\n*Players*: ' .. '_' .. jdat.players.now .. '_' .. '_/_' .. '_' .. jdat.players.max .. '_' .. '\n*Version*: ' .. '_' .. jdat.server.name .. '_' .. '\n*Protocol*: ' .. '_' .. jdat.server.protocol .. '_'
	mattata.sendMessage(message.chat.id, output, 'Markdown', true, false, message.message_id)
end

return minecraft