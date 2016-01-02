VehicleSpawners = {
	PlayerVehicles = {}
}

function VehicleSpawners.SpawnVehicle(model,x,y,z,rot)
	VehicleSpawners.RemovePlayerVehicle(client)
	local veh = Vehicle(model,x,y,z+4,0,0,rot)
	client:warpIntoVehicle(veh)
	VehicleSpawners.PlayerVehicles[client] = veh
end
addEvent("SAOS.UseVehicleSpawner",true)
addEventHandler("SAOS.UseVehicleSpawner",root,VehicleSpawners.SpawnVehicle)

function VehicleSpawners.RemovePlayerVehicle(player)
	if VehicleSpawners.PlayerVehicles[player] then
		VehicleSpawners.PlayerVehicles[player]:destroy()
	end
end