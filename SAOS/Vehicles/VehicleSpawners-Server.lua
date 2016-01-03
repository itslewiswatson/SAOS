VehicleSpawners = {
	PlayerVehicles = {}
}

function VehicleSpawners.SpawnVehicle(model,x,y,z,rot)
	VehicleSpawners.RemovePlayerVehicle(client)
	local veh = Vehicle(model,x,y,z+4,0,0,rot)
	warpPedIntoVehicle(client,veh)
	VehicleSpawners.PlayerVehicles[client] = veh
	addEventHandler("onVehicleExplode",veh,VehicleSpawners.VehicleExploded)
end
addEvent("SAOS.UseVehicleSpawner",true)
addEventHandler("SAOS.UseVehicleSpawner",root,VehicleSpawners.SpawnVehicle)

function VehicleSpawners.RemovePlayerVehicle(player)
	if VehicleSpawners.PlayerVehicles[player] then
		destroyElement(VehicleSpawners.PlayerVehicles[player])
	end
end

function VehicleSpawners.VehicleExploded()
	setTimer(function(veh)
		if isElement(veh) then
			veh:destroy()
		end
	end,10000,1,source)
end