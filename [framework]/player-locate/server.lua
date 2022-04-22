-- [1] Player Connecting --
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
	-- Variable Creation --
	local source = source
	local identifiers = GetPlayerIdentifiers(source)
	local steamid
	local license
	local discord
	local fivem
	local ip
	-- Defining the variable as user's identifiers--
	for k, v in ipairs(identifiers) do
		if string.match(v, 'steam') then
			steamid = v
			print('steamid grabbed:', v)
		elseif string.match(v, 'license:') then
			license = v
		elseif string.match(v, 'discord') then
			discord = v
		elseif string.match(v, 'fivem') then
			fivem = v
		elseif string.match(v, 'ip') then
			ip = v
		end
	end
--Check if the user has a steamid --
	if not steamid then
		deferrals.done('You need to open Steam')
-- If they do have a steamidm they can join --
	else
		deferrals.done()
		print('steamid is being fetched')
-- Check if the user's steamid is in the database --
		MySQL.Async.fetchScalar('SELECT 1 FROM user_identifiers WHERE steamid = @steamid', {
			['@steamid'] = steamid
		}, function(result)
-- If the user's steamid is not in the database, grab their identifiers and put them into the database --
			if not result then
				print('steamid not found, inserting identifiers into database.')
-- SQL query to insert indentifiers into database --
				MySQL.Async.execute('INSERT INTO user_identifiers (steamname, steamid, license, discord, fivem, ip) VALUE (@steamname, @steamid, @license, @discord, @fivem, @ip)',
					{ ['@steamname'] = GetPlayerName(source), ['@steamid'] = steamid, ['@license'] = license, ['@discord'] = discord, ['@fivem'] = fivem, ['@ip'] = ip })
				MySQL.Async.execute('INSERT INTO user_information (steamname, steamid) VALUE (@steamname, @steamid)',{
					['@steamname'] = GetPlayerName(source), ['@steamid'] = steamid
				})
				print('Identifier inserted into database')
			else
-- If the user's steamid is in the database, allow them to join with no further action needed --
				print('steamid found')
			end
		end)
	end
end)


-- [2] Player Spawning --
RegisterServerEvent('Framework:SpawnPlayer')
AddEventHandler('Framework:SpawnPlayer', function()
	-- Variable creation --
	local source = source
	local identifiers = GetPlayerIdentifiers(source)
	for k, v in ipairs(identifiers) do
		if string.match(v, 'steam') then
			steamid = v
			break
		end
	end
	--Get the user's position from the database --
	MySQL.Async.fetchAll('SELECT * FROM user_information WHERE steamid = @steamid', {
		['@steamid'] = steamid
	}, function(result)
		local SpawnPos = json.decode(result[1].position)

		TriggerClientEvent('Framework:LastPosition', source, SpawnPos[1], SpawnPos[2], SpawnPos[3])
		print('Trigger client event: LastPosition')
	end)
end)


-- Save the player position --
RegisterServerEvent('Framework:SavePlayerPosition')
AddEventHandler('Framework:SavePlayerPosition', function(PosX, PosY, PosZ)
	local source = source
	local identifiers = GetPlayerIdentifiers(source)
	for k, v in ipairs(identifiers) do
		if string.match(v, 'steam') then
			steamid = v
			break
		end
	end
	MySQL.Async.execute('UPDATE user_information SET position = @position WHERE steamid = @steamid', {
		['@steamid'] = steamid,
		['@position'] = '{' .. PosX .. ', ' .. PosY .. ', ' .. PosZ ..'}'
	})
	print('Player position saved.')
end)
