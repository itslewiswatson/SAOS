Jobs = {
	Teams = {},
	JobData = {}
}

function Jobs.Setup()
	if Config.GetValue("civilians_enabled") ~= "false" then
		Jobs.Teams["Civilians"] = createTeam("Civilians",255,215,0)
	end
	if Config.GetValue("emergency_services_enabled") ~= "false" then
		Jobs.Teams["Emergency Services"] = createTeam("Emergency Services",0,255,255)
		Jobs.JobData["Paramedic"] = {"Emergency Services",274,{{41,500}}}
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
	exports.scoreboard:scoreboardAddColumn("job",root,100,"Job",10)
end

function Jobs.SpawnHandler(player)
	local job = player:getData("job")
	if job and Jobs.JobData[job] and Jobs.Teams[Jobs.JobData[job][1]] then
		player:setTeam(Jobs.Teams[Jobs.JobData[job][1]])
	elseif not job and Jobs.Teams["Unemployed"] then
		setPlayerTeam(player,Jobs.Teams["Unemployed"])
	end
end

function Jobs.RequestJob(job)
	local jobData = Jobs.JobData[job]
	if jobData and Jobs.Teams[jobData[1]] then
		client:setTeam(Jobs.Teams[jobData[1]])
		client:setModel(jobData[2])
		if jobData[3] then
			for k, v in ipairs(jobData[3]) do
				giveWeapon(client,v[1],v[2],v[3])
				setWeaponAmmo(client,v[1],v[2])
			end
		end
		client:setData("job",job)
	end
end
addEvent("SAOS.RequestJob",true)
addEventHandler("SAOS.RequestJob",root,Jobs.RequestJob)

addEventHandler("onResourceStart",root,function(resource)
	if getResourceName(resource) == "scoreboard" then
		exports.scoreboard:scoreboardAddColumn("job",root,100,"Job",10)
	end
end)