Jobs = {
	Teams = {}
}

function Jobs.Setup()
	if Config.GetValue("civilians_enabled") ~= "false" then
		Jobs.Teams["Civilians"] = createTeam("Civilians",255,215,0)
	end
	if Config.GetValue("emergency_services_enabled") ~= "false" then
		Jobs.Teams["Emergency Services"] = createTeam("Emergency Services",0,255,255)
	end
	if Config.GetValue("law_enforcement_enabled") ~= "false" then
		Jobs.Teams["Law Enforcement"] = createTeam("Law Enforcement",65,105,225)
	end
	if Config.GetValue("armed_forces_enabled") ~= "false" then
		Jobs.Teams["Armed Forces"] = createTeam("Armed Forces",34,139,34)
	end
	if Config.GetValue("criminals_enabled") ~= "false" then
		Jobs.Teams["Criminals"] = createTeam("Criminals",255,0,0)
	end
	Jobs.Teams["Unemployed"] = createTeam("Unemployed",139,137,137)
	for k, v in ipairs(getElementsByType("player")) do
		Jobs.SpawnHandler(v)
	end
end

function Jobs.SpawnHandler(player)
	local job = player:getData("job")
	if not job and Jobs.Teams["Unemployed"] then
		setPlayerTeam(player,Jobs.Teams["Unemployed"])
	end
end