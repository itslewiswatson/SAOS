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
	Jobs.Teams["Off-Duty"] = createTeam("Off-Duty",255,165,0)
	Jobs.Teams["Unemployed"] = createTeam("Unemployed",139,137,137)
	for k, v in ipairs(getElementsByType("player")) do
		Jobs.SpawnHandler(v)
	end
end

function Jobs.SpawnHandler(player)
	local job = player:getData("job")
	if job and Jobs.JobData[job] and Jobs.Teams[Jobs.JobData[job][1]] then
		player:setTeam(Jobs.Teams[Jobs.JobData[job][1]])
	elseif not job and Jobs.Teams["Unemployed"] then
		setPlayerTeam(player,Jobs.Teams["Unemployed"])
	end
end

function Jobs.ApplyJob(player,job,weapons)
	local jobData = Jobs.JobData[job]
	if jobData and Jobs.Teams[jobData[1]] then
		player:setTeam(Jobs.Teams[jobData[1]])
		player:setModel(player:getData("jobSkin") or jobData[2])
		player:setData("jobSkin",player:getModel())
		if weapons and jobData[3] then
			for k, v in ipairs(jobData[3]) do
				giveWeapon(player,v[1],v[2],v[3])
				setWeaponAmmo(player,v[1],v[2])
			end
		end
		player:setData("job",job)
		player:setData("jobActive",true)
	end
end

function Jobs.PlayerResign(source)
	local job = source:getData("job")
	if job then
		local jobData = Jobs.JobData[job]
		if jobData and jobData[3] then
			for k, v in ipairs(jobData[3]) do
				takeWeapon(source,v[1],v[2])
			end
		end
		source:setTeam(Jobs.Teams["Unemployed"] and Jobs.Teams["Unemployed"] or nil)
		source:setModel(source:getData("skin") or 0)
		source:removeData("job")
		source:removeData("jobSkin")
		outputChatBox(string.format(Utils.GetL10N(source,"JOB_RESIGNED"),job),source,255,255,0)
	else
		outputChatBox(string.format(Utils.GetL10N(source,"JOB_NOT_EMPLOYED"),job),source,255,0,0)
	end
end
addCommandHandler("resign",Jobs.PlayerResign,false,false)

function Jobs.RequestJob(job)
	Jobs.ApplyJob(client,job,true)
end
addEvent("SAOS.RequestJob",true)
addEventHandler("SAOS.RequestJob",root,Jobs.RequestJob)