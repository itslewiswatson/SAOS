Vehicles = {}

function Vehicles.Setup()
	if Config.GetValue("newbie_vehicles_enabled") ~= "false" then
		local model = Config.GetValue("newbie_vehicles_model") or 481
		for i=0,20 do
			local veh = createVehicle(getVehicleNameFromModel(model) ~= "" and model or 481,1676.7275390625-(i*2),-2310.2900390625,13.058186531067,0,0,147)
			veh:toggleRespawn(true)
			veh:setRespawnDelay(5000)
			veh:setIdleRespawnDelay(60000)
		end
	end
end