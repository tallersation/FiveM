RegisterCommand("send", function(source, args)
	local argString = table.concat(args, " ")
	MySQL.Async.fetchAll("INSERT INTO datatable (ID, SteamName, data) VALUE (@source, @name, @args)",
	{["@source"] = GetPlayerIdentifiers(source)[1], ["@name"] = GetPlayerName(source), ["@args"] = argString},
		function (result)

			TriggerClientEvent("display", source, "^3" .. argString .. "^0")
	end)
end)
