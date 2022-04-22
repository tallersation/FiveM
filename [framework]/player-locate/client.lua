-- When spawn player ped --

AddEventHandler('playerSpawned', function()
	TriggerServerEvent('Framework:SpawnPlayer')
	print('Triggered server event: spawnPlayer')
end)

-- Setup the player position --
RegisterNetEvent('Framework:LastPosition')
AddEventHandler('Framework:LastPosition', function()
	Citizen.Wait(1)
	local defaultModel = GetHashKey('mp_m_freemode_01')
	RequestModel(defaultModel)
	while not HasModelLoaded(defaultModel) do
		Citizen.Wait(1)
	end
	SetPlayerModel(PlayerId(), defaultModel)
	SetPedDefaultComponentVariation(PlayerPedId())
	SetModelAsNoLongerNeeded(defaultModel)

	SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 1, 0, 0, 1)
	print('Entity coordinates set')
end)

-- Update player position --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		LastX, LastY, LastZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		TriggerServerEvent('Framework:SavePlayerPosition', LastX, LastY, LastZ)
		--print('Player position saved.')--
	end
end)
