Jobs = {
	Teams = {}
}

function Jobs.Setup()
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